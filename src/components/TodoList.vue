<template>
  <div class="px-10">
    <h2 class="text-xl font-bold mb-4 glow">Todo List</h2>
    <div class="space-y-2">
       <div v-for="(todo, index) in todos" :key="index" class="relative flex items-center space-x-2 p-4 bg-white bg-opacity-50 rounded-lg shadow-lg">
         <input
           type="checkbox"
           :checked="todo.completed"
           @change="toggleComplete(index)"
           class="w-5 h-5 accent-blue-500"
         />
         <textarea
           v-model="todo.text"
           @blur="updateTodo(index)"
           :class="['flex-1 bg-transparent border-none outline-none text-black text-lg resize-none overflow-hidden', todo.completed ? 'line-through text-gray-600' : '']"
           :disabled="todo.completed"
           rows="1"
         ></textarea>
         <button
           @click="deleteTodo(index)"
           class="absolute right-2 top-1/2 -translate-y-1/2 text-red-500 hover:text-red-600 transition-colors"
         >
           ✕
         </button>
       </div>
    </div>
     <div class="mt-4 flex space-x-2 mb-[100px]">
       <textarea
         v-model="newTodo"
         placeholder="Add new todo..."
         class="flex-1 p-2 bg-gray-800 rounded-lg shadow-lg border-none outline-none text-white text-lg placeholder-gray-400 resize-none overflow-hidden"
         rows="1"
       ></textarea>
       <button
         @click="addTodo"
         class="px-4 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg shadow-lg text-lg font-bold"
       >
         +
       </button>
     </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'

const todos = ref(JSON.parse(localStorage.getItem('todos') || '[]'))

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

// Watch todos to save to localStorage
watch(todos, (newTodos) => {
  localStorage.setItem('todos', JSON.stringify(newTodos))
}, { deep: true })
</script>

<style scoped>
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

/* 4. Notte profonda (radiale) */
.gradient-deep-night {
  background: radial-gradient(
    circle at top,
    #351f5b,
    #27164d,
    #00082a
  );
}

/* 5. Luce lontana (accent) */
.gradient-accent {
  background: linear-gradient(
    to right,
    #270764,
    #351f5b
  );
}

/* 6. Acqua + cielo */
.gradient-water-sky {
  background: linear-gradient(
    to right,
    #00082a,
    #25164b,
    #351f5b
  );
}

/* Testo consigliato */
.text-on-dark {
  color: #f1edff;
}
</style>