#!/usr/bin/env bash
set -e

DIR_SCRIPT="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BUILD_ARCH="${BUILD_ARCH:=$1}"
BUILD_ARCH="${BUILD_ARCH:=amd64}"

# Create build environment
# cd "$DIR_SCRIPT"/.docker

# docker build . -t vhsgunzo/dwarfs-universal-build-image:latest \
#   --platform linux/amd64,linux/arm64 -f ./Dockerfile.ubuntu

# Build dwarfs
cd "$DIR_SCRIPT"
docker run --rm --platform linux/$BUILD_ARCH \
  --mount type=bind,source="$PWD",target=/workspace \
  --env BUILD_TYPE=clang-release-Os-notest-ninja-static \
  --env BUILD_ARCH="$BUILD_ARCH" \
  --env BUILD_DIST=ubuntu \
  --env CXXFLAGS='-g0 -ffunction-sections -fdata-sections -fvisibility=hidden -fmerge-all-constants' \
  --env LDFLAGS='-Wl,--gc-sections -Wl,--strip-all' \
  --env MAKEFLAGS="-j$(nproc)" \
  vhsgunzo/dwarfs-universal-build-image:latest
