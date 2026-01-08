export DOCKER_DEFAULT_PLATFORM=linux/amd64
COMPOSE_DEV=docker-compose.yml

# DEVELOPMENT TASKS
install: ## Install dependencies
	npm install

dev: ## Start development server
	npm run dev

build-prod: ## Generate production build (Docker compatible)
	docker run --rm -v $(PWD):/app -w /app node:18-alpine sh -c "npm install && npm run build"

preview: ## Preview production build
	npm run preview

lint: ## Run linter
	npm run lint

# DOCKER TASKS
dev-up: dev-down  ## Spin up development compose
	docker compose -f ${COMPOSE_DEV} up -d

dev-up-build: dev-down  ## Build and spin up development compose
	docker compose -f ${COMPOSE_DEV} down -v
	docker compose -f ${COMPOSE_DEV} up --build -d

dev-down: ## Spin down development compose
	docker compose -f ${COMPOSE_DEV} down

docker-build-prod: ## Build production Docker image
	docker build -t smart-pomo:prod .

docker-run-prod: ## Run production Docker container
	docker run -p 80:80 smart-pomo:prod

clean: dev-down ## Clean all docker images
	docker system prune -a --volumes -f

# HELP
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)