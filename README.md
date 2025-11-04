# Docker Image Template

A production-ready Docker image template with CI/CD pipeline for automated testing and deployment.

## Features

- **Ready-to-go Docker setup** - Multi-stage Dockerfile optimized for production
- **Sample Flask application** - Easily replaceable with your own app
- **Automated CI/CD** - GitHub Actions workflow for testing and deployment
- **Health checks** - Built-in health and readiness endpoints
- **Security best practices** - Non-root user, minimal base image
- **Local development** - Docker Compose setup for easy local testing
- **Unit tests** - Pytest configuration with coverage reporting

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # CI/CD pipeline configuration
├── src/
│   ├── app.py                 # Main application
│   └── requirements.txt       # Application dependencies
├── tests/
│   ├── test_app.py           # Unit tests
│   └── requirements.txt       # Test dependencies
├── Dockerfile                 # Docker image definition
├── docker-compose.yml         # Local development setup
├── .dockerignore             # Files to exclude from Docker build
└── pytest.ini                # Pytest configuration
```

## Quick Start

### Local Development

1. **Build and run with Docker Compose:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   - Home: http://localhost:8080
   - Health check: http://localhost:8080/health
   - Readiness check: http://localhost:8080/ready

### Manual Docker Build

```bash
# Build the image
docker build -t myapp:latest .

# Run the container
docker run -p 8080:8080 myapp:latest
```

## Running Tests

### Locally with Python

```bash
# Install dependencies
pip install -r src/requirements.txt
pip install -r tests/requirements.txt

# Run tests
pytest tests/

# Run tests with coverage
pytest tests/ --cov=src --cov-report=html
```

### In Docker

```bash
# Run tests in a container
docker run --rm \
  -v $(pwd):/app \
  python:3.11-slim \
  bash -c "cd /app && pip install -r src/requirements.txt -r tests/requirements.txt && pytest tests/"
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) automatically:

1. **On Pull Requests & Pushes:**
   - Runs unit tests
   - Generates coverage reports
   - Builds Docker image (without pushing)

2. **On Merge to Main Branch:**
   - Runs all tests
   - Builds and pushes Docker image to GitHub Container Registry (ghcr.io)
   - Tags image with:
     - `latest`
     - Branch name
     - Commit SHA
   - Triggers deployment (customize deployment step)

### Setting Up CI/CD

1. **Enable GitHub Actions** in your repository settings

2. **Configure Container Registry permissions:**
   - Go to repository Settings → Actions → General
   - Under "Workflow permissions", select "Read and write permissions"

3. **Customize deployment** in `.github/workflows/ci-cd.yml`:
   - Uncomment and configure the deployment step for your platform
   - Add necessary secrets (SSH keys, cloud credentials, etc.)

### Available Deployment Options

The workflow includes commented examples for:
- Kubernetes deployment
- SSH-based deployment
- AWS ECS
- Google Cloud Run
- Azure Container Instances

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Application port |
| `VERSION` | `1.0.0` | Application version |
| `DEBUG` | `false` | Enable debug mode |

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Home endpoint with app info |
| `/health` | GET | Health check for monitoring |
| `/ready` | GET | Readiness check for orchestration |

## Customization

### Replace with Your Own Application

1. **Replace the application code** in `src/`
2. **Update dependencies** in `src/requirements.txt`
3. **Update the Dockerfile** if needed for your runtime
4. **Update tests** in `tests/`
5. **Configure deployment** in `.github/workflows/ci-cd.yml`

### Supported Languages

While this template uses Python, you can easily adapt it for:
- Node.js
- Go
- Java
- Ruby
- PHP
- Any language with Docker support

Just update the Dockerfile base image and build commands accordingly.

## Security Considerations

- Application runs as non-root user (UID 1000)
- Uses minimal `python:3.11-slim` base image
- Health checks for container orchestration
- Secrets managed via GitHub Actions secrets
- No sensitive data in image layers

## Docker Image Registry

By default, images are pushed to GitHub Container Registry (ghcr.io). To use a different registry:

1. Update `REGISTRY` in `.github/workflows/ci-cd.yml`
2. Add registry credentials to GitHub Secrets
3. Update login action accordingly

### Alternative Registries

- **Docker Hub:** `docker.io`
- **AWS ECR:** `<account-id>.dkr.ecr.<region>.amazonaws.com`
- **Google Artifact Registry:** `<region>-docker.pkg.dev`
- **Azure Container Registry:** `<registry-name>.azurecr.io`

## Troubleshooting

### Build Failures

```bash
# Check Dockerfile syntax
docker build --no-cache -t myapp:latest .

# View build logs
docker build -t myapp:latest . 2>&1 | tee build.log
```

### Container Issues

```bash
# View container logs
docker logs myapp

# Exec into running container
docker exec -it myapp /bin/sh

# Check health status
docker inspect --format='{{.State.Health.Status}}' myapp
```

### CI/CD Issues

- Verify GitHub Actions permissions are set correctly
- Check that GITHUB_TOKEN has registry access
- Review workflow logs in the Actions tab

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests locally
5. Submit a pull request

## License

MIT License - feel free to use this template for any project.

## Support

For issues and questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review GitHub Actions documentation
