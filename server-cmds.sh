#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e


export IMAGE=$1
docker-compose -f docker-compose.yaml up --detach
echo "success"
