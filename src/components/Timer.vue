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
     <div class="mt-4 flex justify-center space-x-4">
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
import { ref, computed, onMounted } from 'vue'

const totalTime = ref(25 * 60) // 25 minutes in seconds
const remainingTime = ref(totalTime.value)
const isRunning = ref(false)
const intervalId = ref(null)

const formattedTime = computed(() => {
  const minutes = Math.floor(remainingTime.value / 60)
  const seconds = remainingTime.value % 60
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
})

const progress = computed(() => remainingTime.value / totalTime.value)

const circumference = 2 * Math.PI * 70

const borderColor = computed(() => {
  if (!isRunning.value) return '#f59e0b' // yellow when paused
  if (progress.value > 0.5) return '#10b981' // green
  if (progress.value > 0.2) return '#f59e0b' // yellow
  return '#ef4444' // red
})

const startTimer = () => {
  if (!isRunning.value) {
    isRunning.value = true
    intervalId.value = setInterval(() => {
      if (remainingTime.value > 0) {
        remainingTime.value--
      } else {
        playAlarm()
        resetTimer()
      }
    }, 1000)
  }
}

const pauseTimer = () => {
  if (isRunning.value) {
    clearInterval(intervalId.value)
    isRunning.value = false
  }
}

const resetTimer = () => {
  clearInterval(intervalId.value)
  isRunning.value = false
  remainingTime.value = totalTime.value
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