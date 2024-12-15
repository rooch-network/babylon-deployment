#!/bin/bash
set -euo pipefail

# Stop the rooch container
docker compose -f "$(pwd)/docker/docker-compose-rooch.yml" down

# Remove the rooch volume
docker volume ls --filter name=rooch_data --format='{{.Name}}' | xargs -r docker volume rm