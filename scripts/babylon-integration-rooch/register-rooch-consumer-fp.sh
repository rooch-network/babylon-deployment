#!/bin/bash
set -euo pipefail

# Load environment variables
set -a
source $(pwd)/.env.babylon-integration
set +a

# check if the Rooch consumer FP already exists
EXISTING_ROOCH_FP_MONIKER=$(docker exec consumer-finality-provider /bin/sh \
    -c "/bin/fpd list-finality-providers" \
    | jq '.finality_providers[0].description.moniker')
EXISTING_ROOCH_FP_EOTS_PK_HEX=$(docker exec consumer-finality-provider /bin/sh \
    -c "/bin/fpd list-finality-providers" \
    | jq -r '.finality_providers[0].btc_pk_hex')
if [ "$EXISTING_ROOCH_FP_MONIKER" == "$ROOCH_FP_MONIKER" ]; then
    echo "Rooch consumer finality provider already exists with \
moniker: $EXISTING_ROOCH_FP_MONIKER and \
EOTS PK: $EXISTING_ROOCH_FP_EOTS_PK_HEX"
    exit 0
fi

# create FP for the consumer chain
echo "Creating Rooch consumer finality provider..."
Rooch_FP_EOTS_PK_HEX=$(docker exec consumer-finality-provider /bin/sh \
    -c "/bin/fpd create-finality-provider \
    --key-name $CONSUMER_FINALITY_PROVIDER_KEY \
    --chain-id $CONSUMER_ID \
    --moniker \"$Rooch_FP_MONIKER\"" | jq -r '.btc_pk_hex')
echo "ROOCH_FP_EOTS_PK_HEX: $ROOCH_FP_EOTS_PK_HEX"
echo
sleep 5

echo "Registering Rooch consumer finality provider..."
ROOCH_FP_REGISTRATION_TX_OUTPUT=$(docker exec consumer-finality-provider /bin/sh \
    -c "/bin/fpd register-finality-provider $ROOCH_FP_EOTS_PK_HEX")
echo "$ROOCH_FP_REGISTRATION_TX_OUTPUT"
echo