<template>
  <div class="text-center">
    <div class="relative inline-block">
      <svg width="300" height="300" viewBox="0 0 120 120" class="timer-circle">
        <circle
          cx="60"
          cy="60"
          r="50"
          fill="none"
          stroke="#e5e7eb"
          stroke-width="4"
        />
        <circle
          cx="60"
          cy="60"
          r="50"
          fill="none"
          :stroke="borderColor"
          stroke-width="4"
          :stroke-dasharray="`${progress * circumference} ${circumference}`"
          stroke-linecap="round"
          transform="rotate(-90 60 60)"
          class="timer-border"
          :style="{ filter: `drop-shadow(0 0 10px ${borderColor})` }"
        />
      </svg>
      <div class="absolute inset-0 flex items-center justify-center">
        <div class="text-6xl md:text-7xl font-mono select-none">
          {{ formattedTime }}
        </div>
      </div>
    </div>
    <div class="mt-4 flex justify-center space-x-4">
      <button
        @click="startTimer"
        class="px-6 py-3 bg-blue-600 hover:bg-blue-500 rounded-lg glow transition-all duration-300"
        :disabled="isRunning"
      >
        Start
      </button>
      <button
        @click="pauseTimer"
        class="px-6 py-3 bg-yellow-600 hover:bg-yellow-500 rounded-lg glow transition-all duration-300"
        :disabled="!isRunning"
      >
        Pause
      </button>
      <button
        @click="resetTimer"
        class="px-6 py-3 bg-red-600 hover:bg-red-500 rounded-lg glow transition-all duration-300"
      >
        Reset
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

const circumference = 2 * Math.PI * 50

const borderColor = computed(() => {
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

onMounted(() => {
  // Ensure audio context is resumed on user interaction
  document.addEventListener('click', () => {
    if (audioContext && audioContext.state === 'suspended') {
      audioContext.resume()
    }
  })
})
</script>

<style scoped>
.timer-circle {
  transition: all 0.3s ease;
}

.timer-border {
  transition: stroke 0.3s ease, filter 0.3s ease;
}
</script>