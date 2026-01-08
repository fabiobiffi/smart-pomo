<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-900 via-purple-900 to-black text-white flex flex-col items-center justify-start px-4 py-8">
    <Timer />
    <TodoList class="mt-8 w-full max-w-md" />
  </div>
</template>

<script setup>
import Timer from './components/Timer.vue'
import TodoList from './components/TodoList.vue'
</script>