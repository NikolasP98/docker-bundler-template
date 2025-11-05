# Multi-stage build for optimal image size
FROM python:3.12-slim AS base

# Set working directory
WORKDIR /app

# Install system dependencies and uv
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

# Copy project files
COPY pyproject.toml uv.lock README.md ./

# Install dependencies using uv (production only, no dev dependencies)
RUN uv sync --frozen --no-dev

# Copy application code
COPY src/ ./src/

# Create non-root user for security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8080/health')" || exit 1

# Use gunicorn for production via uv
CMD ["/app/.venv/bin/gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "--timeout", "60", "--chdir", "/app/src", "app:app"]
