#/bin/sh
VERSION="v0.20.99.0"
GIT_REPO="github.com/blockstackpbc/bitcoin-neon-controller.git"
stty -echo
printf "(neon) Enter github user: "
read GIT_USER
printf "\n"
printf "(neon) Enter github key: "
read GIT_PASS
printf "\n"
if [[ $GIT_USER == "" || $GIT_PASS == "" ]];then
  stty echo
  echo "Missing github auth for $GIT_REPO"
  exit 1
fi
printf "(nginx) Enter Maxmind License Key (1Password): "
read LICENSE_KEY
stty echo
printf "\n"
if [[ $LICENSE_KEY == "" ]];then
  echo "Missing maxmind license"
  exit 1
fi

echo "Building bitcoin-${VERSION}"
docker build \
  -f Dockerfile-bitcoind.alpine \
  -t quay.io/blockstack/bitcoind:${VERSION} \
  -t blockstack/bitcoind:${VERSION} \
  ..
docker push quay.io/blockstack/bitcoind:${VERSION} \
  && docker push blockstack/bitcoind:${VERSION}
echo "Done"
echo ""
echo ""
echo "Building p2p-firewall"
docker build \
  -f Dockerfile.p2p-firewall \
  -t quay.io/blockstack/bitcoind:p2p-firewall \
  -t blockstack/bitcoind:p2p-firewall \
  ..
docker push quay.io/blockstack/bitcoind:p2p-firewall \
  && docker push blockstack/bitcoind:p2p-firewall
echo "Done"
echo ""
echo ""
echo "Building bitcoin-neon-controller"
docker build \
  --build-arg GIT_USER=${GIT_USER} \
  --build-arg GIT_PASS=${GIT_PASS} \
  -f Dockerfile.neon \
  -t quay.io/blockstack/bitcoind:neon \
  -t blockstack/bitcoind:neon \
  ..
docker push quay.io/blockstack/bitcoind:neon \
  && docker push blockstack/bitcoind:neon
echo "Done"
echo ""
echo ""
echo "Building openresty nginx"
docker build \
  --build-arg LICENSE_KEY=${LICENSE_KEY} \
  -f Dockerfile.nginx \
  -t quay.io/blockstack/bitcoind:nginx \
  -t blockstack/bitcoind:nginx \
  ..
docker push quay.io/blockstack/bitcoind:nginx
  && docker push blockstack/bitcoind:nginx
echo "Done"
