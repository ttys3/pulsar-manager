#!/usr/bin/env bash

set -eou pipefail

rm -rf .gradle
rm -rf front-end/.gradle

# generate build/distributions/pulsar-manager.tar
podman run --rm -ti -v $(pwd):/build -w /build openjdk:8-jdk sh -c './gradlew build -x test'

ls -l build/distributions

cd front-end

podman run --rm -ti -v $(pwd):/build -w /build node:12.22.10-buster-slim sh -c 'npm install && npm rebuild node-sass && npm run build:prod'
cd ..

podman build -t pulsar-manager:v0.3.0-candidate-3 -f ./docker/Dockerfile .
podman push pulsar-manager:v0.3.0-candidate-3 docker.io/80x86/pulsar-manager:v0.3.0-candidate-3



