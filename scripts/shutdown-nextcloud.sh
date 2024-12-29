#!/bin/bash

# Create a shutdown script (save as nextcloud-aio-stop.sh)

# Function to safely stop a container
stop_container() {
    local container=$1
    local wait_time=$2
    echo "Stopping $container..."
    docker stop --time=40 $container  # Give containers up to 40 seconds to stop gracefully
    sleep $wait_time
    echo "✓ $container stopped"
}

echo "Beginning safe shutdown of Nextcloud AIO containers..."

# Stop in reverse order of dependencies

# First stop user-facing services
stop_container nextcloud-aio-whiteboard 5
stop_container nextcloud-aio-talk 5
stop_container nextcloud-aio-collabora 5
stop_container nextcloud-aio-fulltextsearch 5
stop_container nextcloud-aio-imaginary 5

# Stop notification service before main application
stop_container nextcloud-aio-notify-push 5   # Added this line for notify-push

# Stop main application
stop_container nextcloud-aio-nextcloud 10    # Give extra time for clean shutdown

# Stop web server
stop_container nextcloud-aio-apache 5

# Stop support services
stop_container nextcloud-aio-redis 5

# Stop database last to ensure all writes are complete
stop_container nextcloud-aio-database 10

echo "Verifying all containers are stopped..."
docker ps | grep nextcloud-aio

echo "Shutdown complete!"