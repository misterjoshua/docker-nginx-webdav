#!/bin/bash -e

echo "Installing configuration"
/install.sh

echo "Starting docker-php-entrypoint $*"
docker-php-entrypoint $*