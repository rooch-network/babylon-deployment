#!/bin/bash
set -euo pipefail

# Load environment variables from .env.bitcoin and .env.rooch file
set -a
source "$(pwd)/.env.bitcoin"
source "$(pwd)/.env.rooch"
set +a

echo "ROOCH_NETWORK: $ROOCH_NETWORK"
echo "BITCOIN_RPC_HOST: $BITCOIN_RPC_HOST"
echo "BITCOIN_RPC_USER: $BITCOIN_RPC_USER"
echo "BITCOIN_RPC_PASS: $BITCOIN_RPC_PASS"

if [[ "ROOCH_NETWORK" != "local" && "$NETWORK" != "dev" && "$NETWORK" != "test" && "$NETWORK" != "main" ]]; then
  echo "Unsupported rooch network: ROOCH_NETWORK"
  exit 1
fi

echo "Starting rooch..."
#docker run -d --name rooch-mainnet --restart unless-stopped -v /data:/root -p 6767:6767 -p 9184:9184 -e RUST_BACKTRACE=full  "ghcr.io/rooch-network/rooch:$REF" \
server start -n -${ROOCH_NETWORK} \
--btc-sync-block-interval 20 \
--btc-rpc-url "$BITCOIN_RPC_HOST" \
--btc-rpc-username "$BITCOIN_RPC_USER" \
--btc-rpc-password "$BITCOIN_RPC_PASS" \
#--da "{\"da-backend\": {\"backends\": [{\"open-da\": {\"scheme\": \"gcs\", \"config\": {\"bucket\": \"$OPENDA_GCP_MAINNET_BUCKET\", \"credential\": \"$OPENDA_GCP_MAINNET_CREDENTIAL\"}}}]}}" \
--traffic-burst-size 200 \
--traffic-per-second 0.1