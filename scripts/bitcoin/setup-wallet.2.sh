#!/bin/bash
#set -euo pipefail
source "$(pwd)/.env.bitcoin"

echo "NETWORK: $NETWORK"
echo "BTC_WALLET_NAME: $BTC_WALLET_NAME"

#DATA_DIR=/bitcoind/.bitcoin
DATA_DIR=~/.bitcoin/data

if [[ ! -d "${DATA_DIR}/regtest/wallets/${BTC_WALLET_NAME}" ]]; then
  echo "Creating a wallet ${BTC_WALLET_NAME}..."
  bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass createwallet btcwallet false false walletpass false false
fi

echo "Opening wallet ${BTC_WALLET_NAME}..."
bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass -rpcwallet=btcwallet walletpassphrase walletpass 10
echo "Importing the private key to the wallet ${BTC_WALLET_NAME} with the label ${BTC_WALLET_NAME} without rescan..."
bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass -rpcwallet=btcwallet importprivkey "$BTC_PRIVKEY" btcwallet false

if [[ "$NETWORK" == "regtest" ]]; then
  echo "Generating 110 blocks for the first coinbases to mature..."
  bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass -rpcwallet=btcwallet -generate 110

  # Waiting for the wallet to catch up.
  sleep 5
  echo "Checking balance..."
  bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass -rpcwallet=btcwallet getbalance
  
  echo "Getting the imported BTC address for wallet ${BTC_WALLET_NAME}..."
  BTC_ADDR=$(bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass -rpcwallet=btcwallet getaddressesbylabel btcwallet | jq -r 'keys[0]')
  echo "Imported BTC address: ${BTC_ADDR}"

  if [[ -z "$GENERATE_INTERVAL_SECS" ]]; then
    GENERATE_INTERVAL_SECS=600 # 10 minutes
  fi

  # without it, regtest will not mine blocks
  echo "Starting block generation every $GENERATE_INTERVAL_SECS seconds in the background..."
  (
    while true; do
      bitcoin-cli -regtest -rpcuser=roochuser -rpcpassword=roochpass -rpcwallet=btcwallet -generate 1
      sleep "$GENERATE_INTERVAL_SECS"
    done
  ) &
fi