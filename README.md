# Smart Pomo 🍅

The ultimate Pomodoro timer app with a retro pixel art arcade theme. Boost your productivity with timed work sessions, breaks, and a built-in todo list.

## Features

- **Circular Progress Timer**: Visual countdown with color-changing border (green → yellow → red)
- **Todo List**: Manage tasks alongside your timer
- **Arcade Style**: Pixel art font, retro buttons with click sounds
- **Audio Feedback**: Alarm sound when timer ends, button click effects
- **Responsive Design**: Works on desktop and mobile
- **Docker Support**: Easy deployment and development

## Technologies

- **Frontend**: Vue 3 with Composition API
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **Audio**: Web Audio API for sounds
- **Linting**: ESLint
- **Containerization**: Docker & Docker Compose

## Installation

### Prerequisites

- Node.js 18+
- npm or yarn
- Docker (optional, for containerized setup)

### Local Development

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd smart-pomo
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open [http://localhost:5173](http://localhost:5173) in your browser.

### Docker Setup

1. Build and run with Docker Compose:
   ```bash
   docker compose up --build
   ```

2. Access the app at [http://localhost:5173](http://localhost:5173).

For production builds:
```bash
npm run build
npm run preview
```

## Usage

- **Start Timer**: Click START to begin a 25-minute Pomodoro session
- **Pause/Resume**: Use PAUSE to temporarily stop the timer
- **Reset**: Click RESET to stop and reset the timer
- **Todo List**: Add, edit, and check off tasks
- **Audio**: Interact with buttons for click sounds; timer end triggers an alarm

## Project Structure

```
smart-pomo/
├── public/
│   └── wallpaper.png          # Background image
├── src/
│   ├── components/
│   │   ├── Timer.vue          # Main timer component
│   │   └── TodoList.vue       # Todo list component
│   ├── App.vue                # Root component
│   ├── main.js                # App entry point
│   ├── style.css              # Global styles
│   └── ...
├── Dockerfile                 # Docker build config
├── docker-compose.yml         # Docker Compose setup
├── package.json               # Dependencies and scripts
├── tailwind.config.js         # Tailwind configuration
├── vite.config.js             # Vite configuration
└── README.md                  # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and commit: `git commit -m 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

---

Made with ❤️ for productivity enthusiasts</content>
