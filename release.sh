#!/bin/bash
set -e

rm -rf tmp/build
mkdir -p tmp/build
git archive --format=tar master | tar x -C tmp/build/
cd tmp/build

docker build -f Dockerfile.releaser -t smart_note:releaser .

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
docker run -ti --name smart_note_releaser_${DOCKER_UUID} smart_note:releaser /bin/true
docker cp smart_note_releaser_${DOCKER_UUID}:/opt/smart_note.tar.gz ../
docker rm smart_note_releaser_${DOCKER_UUID}
