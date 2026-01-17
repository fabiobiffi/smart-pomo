 <template>
   <div class="text-center mt-[50px]">
      <div class="relative inline-block">
        <svg width="100%" height="100%" viewBox="0 0 160 160" class="timer-circle w-full md:w-[500px] md:h-[500px] aspect-square mx-auto">
         <defs>
           <filter id="glow">
             <feGaussianBlur stdDeviation="4" result="coloredBlur"/>
             <feMerge>
               <feMergeNode in="coloredBlur"/>
               <feMergeNode in="SourceGraphic"/>
             </feMerge>
           </filter>
         </defs>
         <circle
           cx="80"
           cy="80"
           r="70"
           fill="none"
           stroke="#e5e7eb"
           stroke-width="4"
         />
         <circle
           cx="80"
           cy="80"
           r="70"
           fill="none"
           :stroke="borderColor"
           stroke-width="4"
           :stroke-dasharray="`${progress * circumference} ${circumference}`"
           stroke-linecap="round"
           transform="rotate(-90 80 80)"
           filter="url(#glow)"
           class="timer-border"
         />
      </svg>
       <div class="absolute inset-0 flex items-center justify-center">
          <div :class="['text-[4rem] sm:text-8xl md:text-9xl font-mono select-none']" :style="{ color: borderColor, textShadow: '0 0 20px ' + borderColor }">
            {{ formattedTime }}
          </div>
       </div>
        <div v-if="!isRunning" class="absolute inset-0 flex items-center justify-center" style="margin-top: 140px;">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="currentColor" class="text-yellow-400" filter="url(#glow)">
            <rect x="6" y="4" width="4" height="16"></rect>
            <rect x="14" y="4" width="4" height="16"></rect>
          </svg>
        </div>
    </div>
    </div>
     <div class="mt-4 flex flex-col items-center space-y-4">
      <div class="flex space-x-4">
        <label class="text-white text-xs">
          Work: <input v-model.number="workMinutes" type="number" min="1" max="60" class="w-16 p-1 bg-gray-800 text-white text-xs rounded" /> min
        </label>
        <label class="text-white text-xs">
          Break: <input v-model.number="breakMinutes" type="number" min="1" max="30" class="w-16 p-1 bg-gray-800 text-white text-xs rounded" /> min
        </label>
      </div>
      <div class="flex justify-center space-x-4">
       <button
         @click="startTimer"
         class="px-4 py-2 bg-red-500 hover:bg-red-600 border-4 border-yellow-400 rounded-none shadow-lg transform hover:scale-105 transition-all duration-300 text-sm font-bold"
         :disabled="isRunning"
       >
         START
       </button>
       <button
         @click="pauseTimer"
         class="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 border-4 border-orange-400 rounded-none shadow-lg transform hover:scale-105 transition-all duration-300 text-sm font-bold"
         :disabled="!isRunning"
       >
         PAUSE
       </button>
       <button
         @click="resetTimer"
         class="px-4 py-2 bg-blue-500 hover:bg-blue-600 border-4 border-cyan-400 rounded-none shadow-lg transform hover:scale-105 transition-all duration-300 text-sm font-bold"
       >
         RESET
       </button>
     </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'

// Store the original document title to restore later
const originalTitle = ref(document.title)

// Timer state management
const workMinutes = ref(parseInt(localStorage.getItem('workMinutes') || '25'))
const breakMinutes = ref(parseInt(localStorage.getItem('breakMinutes') || '5'))
const totalTime = ref(workMinutes.value * 60) // in seconds
const remainingTime = ref(totalTime.value)
const isRunning = ref(false)
const isBreak = ref(false)

// Enhanced timing system to prevent Chrome throttling
const intervalId = ref(null)
const startTime = ref(0) // Store when timer started using performance.now()
const pausedTime = ref(0) // Store how much time was already counted when paused
const audioContext = ref(null) // Keep audio context active to prevent aggressive throttling

const formattedTime = computed(() => {
  const minutes = Math.floor(remainingTime.value / 60)
  const seconds = remainingTime.value % 60
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
})

const progress = computed(() => remainingTime.value / totalTime.value)

const circumference = 2 * Math.PI * 70

const borderColor = computed(() => {
  if (isBreak.value) return '#06b6d4' // cyan during break
  if (!isRunning.value) return '#f59e0b' // yellow when paused
  if (progress.value > 0.5) return '#10b981' // green
  if (progress.value > 0.2) return '#f59e0b' // yellow
  return '#ef4444' // red
})

const startTimer = () => {
  if (!isRunning.value) {
    isRunning.value = true
    // Record the start time using high-precision timer
    startTime.value = performance.now()

    // Resume audio context if available (helps prevent Chrome throttling)
    if (audioContext.value && audioContext.value.state === 'suspended') {
      audioContext.value.resume()
    }

    if (!isBreak.value) {
      showNotification('Work time started!')
    } else {
      showNotification('Break time started!')
    }

    // Use setTimeout with shorter intervals for more reliable timing
    // This helps prevent Chrome throttling issues
    const updateTimer = () => {
      if (isRunning.value) {
        // Calculate actual elapsed time since start
        const currentTime = performance.now()
        const elapsedMs = currentTime - startTime.value
        const elapsedSeconds = Math.floor(elapsedMs / 1000)

        // Calculate remaining time based on total time minus elapsed time
        const newRemainingTime = Math.max(0, totalTime.value - elapsedSeconds - pausedTime.value)

        remainingTime.value = newRemainingTime

        if (remainingTime.value > 0) {
          // Continue with shorter timeout for better accuracy
          intervalId.value = setTimeout(updateTimer, 100) // Update every 100ms
        } else {
          // Timer completed
          playAlarm()
          if (!isBreak.value) {
            // Start break
            showNotification('Time for a break!')
            isBreak.value = true
            remainingTime.value = breakMinutes.value * 60
            totalTime.value = breakMinutes.value * 60
            pausedTime.value = 0
            startTime.value = performance.now()
            intervalId.value = setTimeout(updateTimer, 100)
          } else {
            // End break, reset to work
            showNotification('Break over, back to work!')
            resetTimer()
          }
        }
      }
    }

    // Start the timer loop
    intervalId.value = setTimeout(updateTimer, 100)
  }
}

const pauseTimer = () => {
  if (isRunning.value) {
    // Cancel the timeout
    if (intervalId.value) {
      clearTimeout(intervalId.value)
      intervalId.value = null
    }

    // Calculate how much time has elapsed and store it
    const currentTime = performance.now()
    const elapsedMs = currentTime - startTime.value
    const elapsedSeconds = Math.floor(elapsedMs / 1000)
    pausedTime.value += elapsedSeconds

    // Suspend audio context when paused (to save resources)
    if (audioContext.value && audioContext.value.state === 'running') {
      audioContext.value.suspend()
    }

    isRunning.value = false
  }
}

const resetTimer = () => {
  // Cancel any running timeout
  if (intervalId.value) {
    clearTimeout(intervalId.value)
    intervalId.value = null
  }

  // Suspend audio context when reset
  if (audioContext.value && audioContext.value.state === 'running') {
    audioContext.value.suspend()
  }

  isRunning.value = false
  isBreak.value = false
  totalTime.value = workMinutes.value * 60 // reset to work time
  remainingTime.value = totalTime.value
  startTime.value = 0
  pausedTime.value = 0
}

const playClick = () => {
  // Simple click sound using Web Audio API
  const audioContext = new (window.AudioContext || window.webkitAudioContext)()
  const oscillator = audioContext.createOscillator()
  const gainNode = audioContext.createGain()

  oscillator.connect(gainNode)
  gainNode.connect(audioContext.destination)

  oscillator.frequency.value = 600
  oscillator.type = 'square'
  gainNode.gain.setValueAtTime(0.2, audioContext.currentTime)
  gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1)

  oscillator.start(audioContext.currentTime)
  oscillator.stop(audioContext.currentTime + 0.1)
}

onMounted(() => {
  if ('Notification' in window) {
    Notification.requestPermission()
  }

  // Initialize audio context to help prevent Chrome throttling
  try {
    audioContext.value = new (window.AudioContext || window.webkitAudioContext)()
  } catch (e) {
    // Audio context not available, continue without it
  }

  // Handle page visibility changes to maintain accurate timing
  const handleVisibilityChange = () => {
    if (document.hidden) {
      // Tab became hidden - let the timer continue running in background
      // Chrome may throttle, but our timing system will handle it
      return
    }

    // Tab became visible again - check if timing needs correction
    if (isRunning.value) {
      const currentTime = performance.now()
      const elapsedMs = currentTime - startTime.value
      const elapsedSeconds = Math.floor(elapsedMs / 1000)
      const expectedRemaining = totalTime.value - elapsedSeconds - pausedTime.value

      // If there's a significant discrepancy (more than 2 seconds), correct it
      // This handles Chrome's background throttling
      if (Math.abs(expectedRemaining - remainingTime.value) > 2) {
        remainingTime.value = Math.max(0, expectedRemaining)
      }
    }
  }

  // Listen for visibility changes
  document.addEventListener('visibilitychange', handleVisibilityChange)
})

const showNotification = (message) => {
  if ('Notification' in window && Notification.permission === 'granted') {
    new Notification('Smart Pomo', { body: message })
  }
}

const playAlarm = () => {
  // Simple beep sound using Web Audio API
  const audioContext = new (window.AudioContext || window.webkitAudioContext)()
  const oscillator = audioContext.createOscillator()
  const gainNode = audioContext.createGain()

  oscillator.connect(gainNode)
  gainNode.connect(audioContext.destination)

  oscillator.frequency.value = 800
  gainNode.gain.setValueAtTime(0.3, audioContext.currentTime)
  gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 1)

  oscillator.start(audioContext.currentTime)
  oscillator.stop(audioContext.currentTime + 1)
}

// Watchers to update browser tab title with timer status
watch([isRunning, remainingTime, isBreak], () => {
  if (isRunning.value) {
    // Update tab title with current timer value and context
    const timerType = isBreak.value ? 'Break' : 'Work'
    document.title = `${formattedTime.value} - ${timerType} | Smart Pomo`
  } else {
    // Restore original title when timer is not running
    document.title = originalTitle.value
  }
})

// Watchers to update times when inputs change and save to localStorage
watch(workMinutes, (newVal) => {
  localStorage.setItem('workMinutes', newVal.toString())
  if (!isRunning.value && !isBreak.value) {
    totalTime.value = newVal * 60
    remainingTime.value = totalTime.value
  }
})

watch(breakMinutes, (newVal) => {
  localStorage.setItem('breakMinutes', newVal.toString())
  if (isBreak.value && !isRunning.value) {
    totalTime.value = newVal * 60
    remainingTime.value = totalTime.value
  }
})


</script>

<style scoped>
.timer-circle {
  transition: all 0.3s ease;
}

.timer-border {
  transition: stroke 0.3s ease, filter 0.3s ease;
}

/* Gradienti notturni viola/blu */

/* 1. Cielo notturno */
.gradient-sky {
  background: linear-gradient(
    to bottom,
    #351f5b,
    #27164d,
    #00082a
  );
}

/* 2. Tramonto pixel-art */
.gradient-sunset {
  background: linear-gradient(
    135deg,
    #270764,
    #351f5b,
    #25164b
  );
}

/* 3. Mare notturno */
.gradient-sea {
  background: linear-gradient(
    to bottom,
    #000b3b,
    #000934,
    #00082e
  );
}

/* Testo consigliato */
.text-on-dark {
  color: #f1edff;
}
</style>