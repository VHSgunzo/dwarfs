#!/usr/bin/env bash
set -e

DIR_SCRIPT="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for BUILD_ARCH in arm64 amd64
  do
    # Create build environment
    cd "$DIR_SCRIPT"/.docker

    docker build . -t dwarfs --platform linux/$BUILD_ARCH -f ./Dockerfile.ubuntu \
      --build-arg ARCH="$BUILD_ARCH" \
      --build-arg SCRIPT=build-linux.sh

    # Build dwarfs
    cd "$DIR_SCRIPT"
    docker run --rm --user 0:0 \
      --mount type=bind,source="$PWD",target=/workspace \
      --env BUILD_TYPE=clang-release-notest-ninja-static-build \
      --env BUILD_ARCH="$BUILD_ARCH" \
      --env BUILD_DIST=ubuntu \
      --env CFLAGS='-Os -g0 -ffunction-sections -fdata-sections -fvisibility=hidden -fmerge-all-constants' \
      --env LDFLAGS='-Wl,--gc-sections -Wl,--strip-all' \
      dwarfs
done
