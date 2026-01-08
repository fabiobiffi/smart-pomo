<template>
   <div class="min-h-screen text-white flex flex-col">
      <div class="flex flex-col items-center min-h-screen" style="background-image: url(/wallpaper.png); background-repeat: no-repeat; background-size: cover;">
       <Timer />
       <TodoList class="mt-8 w-full max-w-md" />
     </div>
     <section class="mt-12 flex-1 flex flex-col justify-center items-center">
       <div class="w-full max-w-4xl text-center">
         <h2 class="text-base font-bold mb-6">Boost Your Productivity with Smart Pomo</h2>
       <p class="text-xs mb-4">Discover the ultimate Pomodoro timer app designed to enhance your focus and efficiency. Smart Pomo combines the proven Pomodoro Technique with an integrated todo list to help you manage tasks like never before.</p>
       <h3 class="text-base font-semibold mb-4">What is the Pomodoro Technique?</h3>
       <p class="text-xs mb-4">The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. It breaks work into intervals, traditionally 25 minutes long, separated by short breaks. Each interval is known as a Pomodoro, after the tomato-shaped kitchen timer Cirillo used.</p>
       <p class="text-xs mb-4">Smart Pomo implements this technique with a beautiful, responsive circular timer that visually represents your progress. The timer changes color as time runs out, providing clear visual feedback to keep you motivated.</p>
       <h3 class="text-base font-semibold mb-4">Integrated Task Management</h3>
       <p class="text-xs mb-4">Unlike other Pomodoro apps, Smart Pomo includes a built-in todo list right below the timer. Add, manage, and check off your tasks as you work through your Pomodoros. This seamless integration helps you stay organized and focused on what matters most.</p>
       <p class="text-xs mb-4">The todo list is simple yet powerful, allowing you to create tasks quickly and mark them complete. Combine this with the timer to create a complete productivity workflow that maximizes your output.</p>
       <h3 class="text-base font-semibold mb-4">Mobile-First Design</h3>
       <p class="text-xs mb-4">Smart Pomo is fully responsive and optimized for mobile devices. On phones, the timer takes up the full screen width for maximum visibility, while on desktop, it's constrained to a comfortable 500px size. The font size adjusts automatically to ensure readability across all devices.</p>
       <p class="text-xs mb-4">Whether you're working on your smartphone during your commute or at your desk on a large monitor, Smart Pomo provides an optimal experience tailored to your device.</p>
       <h3 class="text-base font-semibold mb-4">Features That Matter</h3>
       <ul class="list-disc list-inside mb-4 text-left max-w-2xl mx-auto text-xs">
         <li>Accurate 25-minute Pomodoro timer with visual progress indicator</li>
         <li>Color-changing border that reflects time remaining (green to yellow to red)</li>
         <li>Audio alerts when timer completes</li>
         <li>Start, pause, and reset functionality</li>
         <li>Integrated todo list for task management</li>
         <li>Responsive design for mobile and desktop</li>
         <li>Clean, distraction-free interface</li>
       </ul>
       <h3 class="text-base font-semibold mb-4">How to Use Smart Pomo</h3>
       <p class="text-xs mb-4">Getting started is easy! Add your tasks to the todo list below the timer. Click START to begin a 25-minute work session. Focus entirely on your task until the timer rings. Take a short 5-minute break, then repeat. After four Pomodoros, take a longer 15-30 minute break.</p>
       <p class="text-xs mb-4">Use the PAUSE button if you need to interrupt your session, and RESET to start over. Mark tasks complete as you finish them to track your progress throughout the day.</p>
       <h3 class="text-base font-semibold mb-4">Why Choose Smart Pomo?</h3>
       <p class="text-xs mb-4">Smart Pomo stands out from other productivity apps with its focus on simplicity and effectiveness. No complicated settings or overwhelming features – just a clean timer and task list that work together to boost your productivity.</p>
       <p class="text-xs mb-4">Built with modern web technologies, Smart Pomo is fast, reliable, and works offline. Whether you're a student, freelancer, or office worker, Smart Pomo can help you develop better work habits and achieve more in less time.</p>
       <h3 class="text-base font-semibold mb-4">Improve Your Focus and Productivity Today</h3>
         <p class="text-xs mb-6">Start using Smart Pomo now and experience the benefits of structured work intervals. Combine the power of the Pomodoro Technique with effective task management to transform your productivity. Download, install, or simply use it in your browser – Smart Pomo is ready when you are.</p>
       </div>
     </section>
     <footer class="text-center py-4 text-xs bg-black bg-opacity-50">
       © 2026 Made with ❤️ by <a href="https://fabiobiffi.com" class="text-blue-400 hover:text-blue-300 underline">Fabio Biffi</a>
     </footer>
   </div>
</template>

<script setup>
import Timer from './components/Timer.vue'
import TodoList from './components/TodoList.vue'
</script>