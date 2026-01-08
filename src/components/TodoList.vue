<template>
  <div>
    <h2 class="text-xl font-bold mb-4 glow">Todo List</h2>
    <div class="space-y-2">
      <div v-for="(todo, index) in todos" :key="index" class="flex items-center space-x-2 p-2 bg-gray-800 rounded-lg shadow-lg">
        <input
          type="checkbox"
          :checked="todo.completed"
          @change="toggleComplete(index)"
          class="w-5 h-5"
        />
        <input
          v-model="todo.text"
          @blur="updateTodo(index)"
          @keyup.enter="updateTodo(index)"
          :class="['flex-1 bg-transparent border-none outline-none text-white', todo.completed ? 'line-through text-gray-500' : '']"
          :disabled="todo.completed"
        />
        <button
          @click="deleteTodo(index)"
          class="text-red-400 hover:text-red-300 transition-colors"
        >
          ✕
        </button>
      </div>
    </div>
    <div class="mt-4">
      <input
        v-model="newTodo"
        @keyup.enter="addTodo"
        placeholder="Add new todo..."
        class="w-full p-2 bg-gray-800 rounded-lg shadow-lg border-none outline-none text-white placeholder-gray-400"
      />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const todos = ref([
  { text: 'Focus on work', completed: false },
  { text: 'Take a break', completed: true },
])

const newTodo = ref('')

const addTodo = () => {
  if (newTodo.value.trim()) {
    todos.value.push({ text: newTodo.value.trim(), completed: false })
    newTodo.value = ''
  }
}

const updateTodo = (index) => {
  if (todos.value[index].text.trim() === '') {
    deleteTodo(index)
  }
}

const deleteTodo = (index) => {
  todos.value.splice(index, 1)
}

const toggleComplete = (index) => {
  todos.value[index].completed = !todos.value[index].completed
}
</script>