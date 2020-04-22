#!/bin/sh
SERVICES+=('clone_repo.service' \
  'pull_repo.timer' \
  'create_docker_network.service' \
  'bitcoin_regtest.service' \
  'blockstack_core.service' \
  'neon.service' \
  'p2p_firewall.service' \
  'testnet.service')

if [ -d /mnt/stateful_partition/bitcoind ]; then
  /usr/bin/git -C /mnt/stateful_partition/bitcoind pull
else
  /usr/bin/git clone -b master --single-branch https://github.com/blockstackpbc/neon-docker /mnt/stateful_partition/bitcoind
fi
for service in "${SERVICES[@]}"; do
  cp -a /mnt/stateful_partition/bitcoind/unit-files/${service}  /etc/systemd/system/${service}
done
/usr/bin/systemctl daemon-reload

cat <<EOF> /mnt/stateful_partition/bitcoind/configs/bitcoin/neon-master-node.toml
[neon]
rpc_bind = "0.0.0.0:18443"
block_time = 20000
miner_private_key = ""
miner_address = ""
bitcoind_rpc_host = "bitcoin_regtest.bitcoind:18443"
bitcoind_rpc_user = "blockstack"
bitcoind_rpc_pass = "blockstacksystem"
EOF

for service in "${SERVICES[@]}"; do
  systemctl enable $service
done

systemctl start testnet
