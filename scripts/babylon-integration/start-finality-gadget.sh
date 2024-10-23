#!/bin/bash
set -euo pipefail

# Load environment variables
set -a
source $(pwd)/.env.babylon-integration
set +a

FINALITY_GADGET_DIR=$(pwd)/.finality-gadget
CONFIGS_DIR=$(pwd)/configs/babylon-integration
FINALITY_GADGET_CONF=$(pwd)/.finality-gadget/opfgd.toml

if [ ! -d "$FINALITY_GADGET_DIR" ]; then
  echo "Creating $FINALITY_GADGET_DIR directory..."
  mkdir -p $FINALITY_GADGET_DIR

  echo "Copying $CONFIGS_DIR/opfgd.toml to $FINALITY_GADGET_CONF..."
  cp $CONFIGS_DIR/opfgd.toml $FINALITY_GADGET_CONF

  # Update the config file with environment variables
  sed -i.bak "s|\${L2_RPC_URL}|$L2_RPC_URL|g" $FINALITY_GADGET_CONF
  sed -i.bak "s|\${BITCOIN_RPC_HOST}|$BITCOIN_RPC_HOST|g" $FINALITY_GADGET_CONF
  sed -i.bak "s|\${BITCOIN_RPC_USER}|$BITCOIN_RPC_USER|g" $FINALITY_GADGET_CONF
  sed -i.bak "s|\${BITCOIN_RPC_PASS}|$BITCOIN_RPC_PASS|g" $FINALITY_GADGET_CONF
  sed -i.bak "s|\${FINALITY_GADGET_ADDRESS}|$FINALITY_GADGET_ADDRESS|g" $FINALITY_GADGET_CONF
  sed -i.bak "s|\${BABYLON_CHAIN_ID}|$BABYLON_CHAIN_ID|g" $FINALITY_GADGET_CONF
  sed -i.bak "s|\${BABYLON_RPC_URL}|$BABYLON_RPC_URL|g" $FINALITY_GADGET_CONF

  rm $FINALITY_GADGET_DIR/opfgd.toml.bak
  echo "Successfully updated the conf file $FINALITY_GADGET_CONF"

  chmod -R 777 $FINALITY_GADGET_DIR
  echo "Successfully initialized $FINALITY_GADGET_DIR directory"
  echo
fi

echo "Starting finality-gadget..."
docker compose -f docker/docker-compose-babylon-integration.yml up -d finality-gadget

echo "Waiting for finality-gadget to start..."
sleep 10