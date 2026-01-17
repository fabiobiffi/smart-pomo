# AGENTS.md - Development Guidelines for Smart Pomo

This document provides comprehensive guidelines for development agents working on the Smart Pomo project, a Vue.js-based Pomodoro timer application with integrated task management.

## Project Overview

Smart Pomo is a productivity app that combines the Pomodoro Technique with a todo list. Built with Vue 3, Vite, and Tailwind CSS, it features a circular timer with visual progress indicators and local storage persistence.

## Build, Lint, and Test Commands

### Development
```bash
# Start development server
npm run dev
# or
make dev

# Start development with Docker
make dev-up
```

### Building
```bash
# Build for production
npm run build
# or
make build-prod

# Preview production build
npm run preview
# or
make preview

# Build production Docker image
make docker-build-prod
```

### Linting
```bash
# Run ESLint (auto-fix enabled)
npm run lint
# or
make lint
```

### Testing
**Note:** No test framework is currently configured. To add tests:
1. Install Vitest: `npm install --save-dev vitest @vue/test-utils`
2. Add test scripts to package.json
3. Create test files in `src/__tests__/` or alongside components

### Docker Operations
```bash
# Start development environment
make dev-up-build

# Stop development environment
make dev-down

# Run production container
make docker-run-prod

# Clean up
make clean
```

## Code Style Guidelines

### Vue.js Conventions

#### Component Structure
- Use Vue 3 Composition API with `<script setup>`
- Separate template, script, and style sections clearly
- Use kebab-case for component file names (e.g., `todo-list.vue`)
- Use PascalCase for component imports and references

#### Template Syntax
- Use `v-for` with `:key` binding for lists
- Use shorthand syntax (`@click`, `:class`, etc.) when appropriate
- Bind dynamic classes with object syntax: `:class="{ 'class-name': condition }"`
- Use computed properties for complex template expressions

#### Script Setup Pattern
```javascript
import { ref, computed, onMounted, watch } from 'vue'

// Reactive data
const todos = ref([])
const isLoading = ref(false)

// Computed properties
const completedTodos = computed(() => todos.value.filter(todo => todo.completed))

// Methods
const addTodo = () => {
  // implementation
}

// Lifecycle hooks
onMounted(() => {
  // initialization
})

// Watchers
watch(todos, (newTodos) => {
  // side effects
}, { deep: true })
```

### JavaScript/TypeScript Style

#### Variable Naming
- Use camelCase for variables, functions, and properties
- Use PascalCase for component names and constructor functions
- Use UPPER_SNAKE_CASE for constants
- Prefix reactive refs with descriptive names (no `data` prefix needed)

#### Imports and Exports
- Group imports by type: Vue imports first, then component imports, then utilities
- Use named imports over default imports when possible
- Order: Vue core, third-party libraries, local components/utilities

```javascript
import { ref, computed, onMounted } from 'vue'
import { formatTime } from '@/utils/time'
import TodoItem from './TodoItem.vue'
```

#### Error Handling
- Use try-catch blocks for async operations
- Provide user-friendly error messages
- Log errors to console for debugging
- Handle edge cases gracefully (empty inputs, network failures)

#### Async Operations
- Use async/await over Promise chains
- Handle loading states appropriately
- Show user feedback during operations

### CSS and Styling

#### Tailwind CSS
- Use utility-first approach with Tailwind classes
- Follow mobile-first responsive design (`sm:`, `md:`, `lg:`)
- Use Tailwind's opacity utilities for transparency effects
- Leverage Tailwind's color palette and spacing scale

#### Custom CSS Classes
- Define custom classes in `<style scoped>` sections
- Use CSS custom properties for theme values
- Apply glow effects using CSS filters and text-shadow
- Maintain consistent color scheme (night theme with purple/blue gradients)

#### Responsive Design
- Mobile-first approach: design for mobile, enhance for desktop
- Use responsive utilities: `md:w-[500px]`, `sm:text-8xl`
- Test on multiple screen sizes
- Ensure touch targets are at least 44px

### File Organization

#### Component Structure
```
src/
├── components/
│   ├── Timer.vue
│   └── TodoList.vue
├── App.vue
├── main.js
└── style.css
```

#### Naming Conventions
- Components: PascalCase filenames, descriptive names
- Utilities: camelCase functions, kebab-case filenames
- Constants: UPPER_SNAKE_CASE

### Git Workflow

#### Commit Messages
Follow conventional commit format:
- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation
- `style:` formatting changes
- `refactor:` code restructuring
- `test:` testing related changes

#### Branching
- `main` branch for production
- Feature branches for development
- Use descriptive branch names: `feature/add-dark-mode`, `fix/timer-bug`

### Performance Considerations

#### Vue.js Optimizations
- Use computed properties for expensive calculations
- Implement proper key bindings in v-for loops
- Use v-memo for expensive operations when appropriate
- Avoid unnecessary re-renders with proper reactive design

#### Bundle Optimization
- Lazy load components if needed
- Minimize third-party dependencies
- Use tree-shaking friendly imports
- Optimize images and assets

### Browser Compatibility

#### Target Browsers
- Modern browsers with ES6+ support
- Mobile browsers (iOS Safari, Chrome Mobile)
- Progressive enhancement approach

#### Feature Detection
- Check for Notification API support
- Use Web Audio API with fallbacks
- Graceful degradation for unsupported features

### Data Persistence

#### localStorage Usage
- Store user preferences (work/break times)
- Persist todo list state
- Handle localStorage errors gracefully
- Validate stored data on load

### Accessibility (a11y)

#### Standards
- Use semantic HTML elements
- Provide alt text for images
- Ensure sufficient color contrast
- Support keyboard navigation
- Announce dynamic content changes

### Security Considerations

#### Client-Side Security
- Sanitize user inputs before storage
- Avoid eval() or innerHTML with user content
- Use CSP headers if deploying to custom domain
- Validate data from localStorage

### Deployment

#### GitHub Pages
- Automatic deployment on main branch push
- Uses Vite build output from `dist/` directory
- Configured via `.github/workflows/deploy.yml`

#### Docker
- Multi-stage build for optimized images
- Production container serves static files
- Configurable via Dockerfile and docker-compose.yml

## Tooling Configuration

### ESLint
- Uses flat config format
- Vue 3 essential rules enabled
- Auto-fix enabled for formatting
- Ignores build artifacts

### Vite
- Vue 3 plugin configured
- Base path configurable via environment
- Fast HMR for development

### Tailwind CSS
- Content paths configured for Vue files
- No custom theme extensions (uses defaults)

## Development Workflow

1. **Setup**: `npm install` or `make install`
2. **Development**: `npm run dev` or `make dev-up`
3. **Linting**: `npm run lint` before commits
4. **Building**: `npm run build` for production
5. **Testing**: Manual testing (no automated tests configured)
6. **Deployment**: Automatic on main branch push

## Code Quality Standards

### Agent Behavior
- **Act as a SENIOR FRONTEND ENGINEER**: Write production-ready, maintainable code following industry best practices
- **Small Functions**: Break down complex logic into small, focused functions (single responsibility principle)
- **Documentation**: Write docstrings for all functions and methods explaining purpose, parameters, and return values
- **Comments**: Add lots of inline comments explaining complex logic, business rules, and non-obvious decisions

- **Readability**: Clear variable names, consistent formatting
- **Maintainability**: Modular components, separation of concerns
- **Performance**: Efficient reactive updates, minimal re-renders
- **User Experience**: Responsive design, intuitive interactions
- **Accessibility**: Screen reader friendly, keyboard accessible

## Common Patterns

### Timer Logic
- Use `setInterval` for countdown with proper cleanup
- Handle pause/resume states correctly
- Persist timer preferences in localStorage
- Provide audio/visual feedback

### Todo Management
- Reactive array of todo objects with text and completed status
- Deep watch for localStorage persistence
- Optimistic UI updates
- Input validation and sanitization

### State Management
- Component-scoped state with Vue reactivity
- localStorage for persistence across sessions
- Computed properties for derived state
- Watchers for side effects

This document should be updated as the project evolves and new patterns emerge.</content>
<parameter name="filePath">AGENTS.md