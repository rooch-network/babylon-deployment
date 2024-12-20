#!/bin/bash
# Copyright (c) RoochNetwork
# SPDX-License-Identifier: Apache-2.0

#set -euo pipefail

# Load environment variables from .env.rooch file
set -a
. "$(pwd)/.env.rooch"
. "$(pwd)/.env.babylon-integration"
set +a


# echo "$(pwd)/.env.rooch"

echo "ROOCH_NETWORK: $ROOCH_NETWORK"
echo "BITCOIN_RPC_HOST: $BITCOIN_RPC_HOST"
echo "BITCOIN_RPC_USER: $BITCOIN_RPC_USER"
echo "BITCOIN_RPC_PASS: $BITCOIN_RPC_PASS"

#sleep 5
#docker image prune -a -f
#docker ps | grep rooch | grep -v faucet | awk '{print $1}' | xargs -r docker stop
#docker ps -a | grep rooch | grep -v faucet | awk '{print $1}' | xargs -r docker rm -f
#docker run -d --name roochnode --restart unless-stopped -v /data:/root -p 6767:6767 -p 9184:9184 -e RUST_BACKTRACE=full  baichuan3/rooch \
# docker run -d --name roochnode --restart unless-stopped -v "$(pwd).testnets/rooch":/home/.rooch -p 6767:6767 -p 9184:9184 -e RUST_BACKTRACE=full  baichuan3/rooch \

docker run -d --name roochnode --restart unless-stopped -v "$(pwd)/.testnets/rooch":/root/.rooch --network artifacts_localnet -p 6767:6767 -p 9184:9184 -e RUST_BACKTRACE=full  baichuan3/rooch \
    server start -n "$ROOCH_NETWORK" \
    --btc-sync-block-interval 3 \
    --btc-rpc-url "$BITCOIN_RPC_HOST" \
    --btc-rpc-username "$BITCOIN_RPC_USER" \
    --btc-rpc-password "$BITCOIN_RPC_PASS" \
    --traffic-burst-size 200 \
    --traffic-per-second 0.1 \
    --da "{\"da-backend\": {\"backends\": [{\"open-da\": {\"scheme\": \"fs\", \"config\": {}}}]}}" \
