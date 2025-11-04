"""
Unit tests for the Flask application.
"""
import sys
import os
import pytest

# Add src directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from app import app


@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_home_endpoint(client):
    """Test the home endpoint returns expected data."""
    response = client.get('/')
    assert response.status_code == 200

    data = response.get_json()
    assert 'message' in data
    assert 'version' in data
    assert 'status' in data
    assert data['status'] == 'healthy'


def test_health_endpoint(client):
    """Test the health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200

    data = response.get_json()
    assert data['status'] == 'healthy'
    assert 'version' in data


def test_ready_endpoint(client):
    """Test the readiness check endpoint."""
    response = client.get('/ready')
    assert response.status_code == 200

    data = response.get_json()
    assert data['status'] == 'ready'
    assert 'version' in data


def test_invalid_endpoint(client):
    """Test that invalid endpoints return 404."""
    response = client.get('/invalid-endpoint')
    assert response.status_code == 404
