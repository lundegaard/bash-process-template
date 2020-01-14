#!/bin/bash

docker run \
  -v "$(pwd):/work" \
  docker.lnd.bz/bats:latest \
  bats "test/process-template.bats"
