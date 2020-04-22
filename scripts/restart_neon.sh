#!/bin/sh
echo "Stopping bitcoind, bitcoin-neon-controller, bitcoin-p2p-firewall, blockstack_core"
systemctl stop bitcoin_regtest
systemctl stop neon
systemctl stop blockstack_core
echo "Wiping regtest chain"
rm -rf /data/bitcoin/regtest
echo "Starting bitcoind"
systemctl start bitcoin_regtest
systemctl start p2p_firewall
echo "Waiting..."
sleep 60
echo "Starting bitcoin-neon-controller"
systemctl start neon
sleep 10
systemctl start blockstack_core
