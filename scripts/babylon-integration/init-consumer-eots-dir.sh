#!/bin/bash
set -euo pipefail

# Load environment variables
set -a
source $(pwd)/.env.babylon-integration
set +a

CONSUMER_EOTS_MANAGER_DIR=$(pwd)/.consumer-eotsmanager
CONFIGS_DIR=$(pwd)/configs/babylon-integration
EOTS_MANAGER_CONF=$(pwd)/.consumer-eotsmanager/eotsd.conf

# Only run if the directory does not exist
if [ ! -d "$CONSUMER_EOTS_MANAGER_DIR" ]; then
  echo "Creating $CONSUMER_EOTS_MANAGER_DIR directory..."
  mkdir -p $CONSUMER_EOTS_MANAGER_DIR
  echo "Copying $CONFIGS_DIR/consumer-eotsd.conf to $EOTS_MANAGER_CONF..."
  cp $CONFIGS_DIR/consumer-eotsd.conf $EOTS_MANAGER_CONF

  chmod -R 777 $CONSUMER_EOTS_MANAGER_DIR
  echo "Successfully initialized $CONSUMER_EOTS_MANAGER_DIR directory"
  echo
fi