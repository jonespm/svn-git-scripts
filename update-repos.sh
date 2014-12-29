#!/bin/bash

# Small script to pull in changes to any local repositories

set -e

cd repos
for dir in *.git
do
  pushd $dir
  git fetch
  popd
done
