#!/bin/bash

set -e

if [[ $(pwd) == *"/deploy" ]]; then
  cd ..
fi

rm -f deploy/tmp/REVISION deploy/tmp/smartnote.tar.gz

GIT_SHA=$(git rev-parse main)

rm -rf tmp/build
mkdir -p tmp/build
git fetch origin main
git archive --format=tar origin/main | tar x -C tmp/build/
cd tmp/build

export DOCKER_BUILDKIT=0
docker build --build-arg GIT_SHA=${GIT_SHA} -f Dockerfile.releaser -t smartnote:releaser .

mkdir -p ../../deploy/tmp

DOCKER_UUID=$(uuidgen)
docker run --name smartnote_releaser_${DOCKER_UUID} smartnote:releaser /bin/true
docker cp smartnote_releaser_${DOCKER_UUID}:/opt/smartnote.tar.gz ../../deploy/tmp
docker cp smartnote_releaser_${DOCKER_UUID}:/opt/REVISION ../../deploy/tmp
docker rm smartnote_releaser_${DOCKER_UUID}
