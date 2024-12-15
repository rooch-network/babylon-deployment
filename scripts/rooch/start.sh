#!/bin/bash
set -euo pipefail

# Load environment variables from .env.rooch file
set -a
source "$(pwd)/.env.rooch"
set +a

# Start the rooch container
echo "Starting the rooch container..."
docker compose -f "$(pwd)/docker/docker-compose-rooch.yml" up -d

# Wait for the rooch node to be ready
echo "Waiting for the rooch node to be ready..."
sleep 5

max_attempts=10
attempt=0
while ! docker exec roochd tx get-transactions-by-order &>/dev/null; do
    sleep 2
    ((attempt++))
    if [ $attempt -ge $max_attempts ]; then
        echo "Timeout waiting for rooch node to be ready."
        exit 1
    fi
done

echo "Rooch node is ready!"
echo