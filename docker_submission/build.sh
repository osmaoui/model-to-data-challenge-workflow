#!/usr/bin/env bash

# Get the script path
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "No version argument supplied. Usage: $0 <version>"
  exit 1
fi

# Get the version argument
VERSION=$1

# Build the Docker image with the specified version
docker build -t submission_test:$VERSION "$SCRIPTPATH"

# Tag the Docker image
docker tag submission_test:$VERSION docker.synapse.org/syn57381674/submission_test:$VERSION

# Push the Docker image
docker push docker.synapse.org/syn57381674/submission_test:$VERSION


