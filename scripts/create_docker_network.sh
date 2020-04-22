#!/bin/sh -x
BINARY="/usr/bin/docker"
NETWORK="bitcoind"
${BINARY} network inspect ${NETWORK} > /dev/null
CHECK=$?
if [[ $CHECK -ne 0 ]];then
  ${BINARY} network create -d bridge ${NETWORK}
fi
exit 0
