#!/bin/bash

# Create a startup script (save as nextcloud-aio-start.sh)

# Function to start a container and verify its health
start_container() {
    local container=$1
    local wait_time=$2
    echo "Starting $container..."
    docker start $container

    # Wait for specified time
    echo "Waiting $wait_time seconds for $container to initialize..."
    sleep $wait_time

    # Check container health
    if docker inspect --format='{{.State.Health.Status}}' $container | grep -q "healthy"; then
        echo "✓ $container is healthy"
    else
        echo "! Warning: $container may not be fully healthy yet"
    fi
}

echo "Starting Nextcloud AIO containers in the correct order..."

# Start core infrastructure
start_container nextcloud-aio-database 20    # Database needs extra time to initialize
start_container nextcloud-aio-redis 10       # Cache service for performance

# Start web server and main application
start_container nextcloud-aio-apache 10      # Web server must be up before Nextcloud
start_container nextcloud-aio-nextcloud 30   # Main application needs time to connect to DB

# Start support services
start_container nextcloud-aio-imaginary 10    # Image processing service
start_container nextcloud-aio-fulltextsearch 10  # Search functionality
start_container nextcloud-aio-collabora 10    # Document editing service
start_container nextcloud-aio-talk 10         # Communication platform
start_container nextcloud-aio-whiteboard 10   # Collaborative whiteboard

echo "All containers have been started. Performing final health check..."
docker ps | grep nextcloud-aio

echo "Startup complete! Your Nextcloud instance should be available shortly."