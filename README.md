# babylon-deployment

## Troubleshooting

1. BTC staker balance null or no unspent outputs

After running `verify-bitcoin-sync-balance.sh`, the BTC staker wallet should be loaded to bitcoind. If not, you will run into null balance or no unspent outputs errors when running `create-btc-delegations.sh`.

To check the wallet balance:

```
docker exec bitcoindsim /bin/sh -c "bitcoin-cli -signet -rpcuser=rpcuser -rpcpassword=rpcpass -rpcwallet=btcstaker listunspent"
```

To check unspent outputs:

```
docker exec bitcoindsim /bin/sh -c "bitcoin-cli -signet -rpcuser=rpcuser -rpcpassword=rpcpass -rpcwallet=btcstaker getbalance"
```

If your wallet balance is 0 or you have no unspent outputs, you may need to re-load the wallet:

```
docker exec bitcoindsim /bin/sh -c "bitcoin-cli -signet -rpcuser=rpcuser -rpcpassword=rpcpass -rpcwallet=btcstaker unloadwallet btcstaker"

docker exec bitcoindsim /bin/sh -c "bitcoin-cli -signet -rpcuser=rpcuser -rpcpassword=rpcpass -rpcwallet=btcstaker loadwallet btcstaker"
```

Now recheck the balance and unspent outputs.