.PHONY: help build run test clean up down logs shell

IMAGE_NAME ?= myapp
TAG ?= latest

help:
	@echo "Available commands:"
	@echo "  make build      - Build Docker image"
	@echo "  make run        - Run container"
	@echo "  make test       - Run tests"
	@echo "  make up         - Start services with docker-compose"
	@echo "  make down       - Stop services"
	@echo "  make logs       - View container logs"
	@echo "  make shell      - Open shell in running container"
	@echo "  make clean      - Remove containers and images"

build:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME):$(TAG) .

run:
	@echo "Running container..."
	docker run -d --name $(IMAGE_NAME) -p 8080:8080 $(IMAGE_NAME):$(TAG)

test:
	@echo "Running tests..."
	pip install -r src/requirements.txt -r tests/requirements.txt
	pytest tests/ --cov=src --cov-report=term-missing

up:
	@echo "Starting services..."
	docker-compose up -d

down:
	@echo "Stopping services..."
	docker-compose down

logs:
	@echo "Showing logs..."
	docker-compose logs -f

shell:
	@echo "Opening shell..."
	docker exec -it $(IMAGE_NAME) /bin/sh

clean:
	@echo "Cleaning up..."
	docker-compose down -v
	docker rm -f $(IMAGE_NAME) 2>/dev/null || true
	docker rmi $(IMAGE_NAME):$(TAG) 2>/dev/null || true
