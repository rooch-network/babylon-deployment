#!/bin/bash
set -euo pipefail

echo "Stopping consumer-eotsmanager..."
docker compose -f docker/docker-compose-babylon-integration.yml down consumer-eotsmanager

echo "Removing consumer-eotsmanager directory..."
sudo rm -rf $(pwd)/.testnets/consumer-eotsmanager

echo "Stopped consumer-eotsmanager"
echo