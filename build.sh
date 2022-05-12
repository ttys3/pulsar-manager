#!/usr/bin/env bash

set -eou pipefail

rm -rf .gradle
rm -rf front-end/.gradle

mkdir -p .gradle/caches

# generate build/distributions/pulsar-manager.tar
# must use dir `pulsar-manager`, it will used as pulsar-manager/bin/pulsar-manager shell script filename
podman run --rm -ti -v "$(pwd)/.gradle/caches":/root/.gradle/caches -v "$(pwd)":/pulsar-manager -w /pulsar-manager openjdk:8-jdk sh -c './gradlew build -x test'

ls -l build/distributions

podman run --rm -ti -v "$(pwd)/front-end":/build -w /build node:12.22.10-buster-slim sh -c 'npm install && npm rebuild node-sass && npm run build:prod'

podman build -t pulsar-manager:v0.3.0-candidate-3 -f ./docker/Dockerfile .
podman push pulsar-manager:v0.3.0-candidate-3 docker.io/80x86/pulsar-manager:v0.3.0-candidate-3



