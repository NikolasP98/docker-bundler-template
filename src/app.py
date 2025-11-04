"""
Simple Flask application for Docker image template.
This serves as a starting point for your containerized application.
"""

from flask import Flask, jsonify
import os

app = Flask(__name__)

# Configuration from environment variables
PORT = int(os.getenv("PORT", 8080))
VERSION = os.getenv("VERSION", "1.0.0")


@app.route("/")
def home():
    """Home endpoint returning application info."""
    return jsonify(
        {"message": "Hello from Docker!", "version": VERSION, "status": "healthy"}
    )


@app.route("/health")
def health():
    """Health check endpoint for container orchestration. THis is a test"""
    return jsonify({"status": "healthy", "version": VERSION}), 200


@app.route("/ready")
def ready():
    """Readiness check endpoint."""
    # Add your readiness checks here (e.g., database connection)
    return jsonify({"status": "ready", "version": VERSION}), 200


if __name__ == "__main__":
    app.run(
        host="0.0.0.0", port=PORT, debug=os.getenv("DEBUG", "False").lower() == "true"
    )
