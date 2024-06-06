# Test Prediction

This document provides the instructions for building, tagging, and pushing a Docker image for test prediction.

## Steps

1. **Build the Docker image**

    ```bash
    docker build . -t submission:v1
    ```

    This command will build the Docker image from the Dockerfile in the current directory and tag it as `submission:v1`.

2. **Tag the Docker image**

    ```bash
    docker tag submission:v1 docker.synapse.org/syn57381674/submission:v1
    ```

    This command will tag the built Docker image with the repository and image name `docker.synapse.org/syn57381674/submission:v1`.

3. **Push the Docker image to the repository**

    ```bash
    docker push docker.synapse.org/syn57381674/submission:v1
    ```

    This command will push the tagged Docker image to the specified Docker repository.

## Notes

- Ensure you have the necessary permissions and authentication to push to the Docker repository `docker.synapse.org/syn57381674`.
- Replace `v1` with the appropriate version number for subsequent builds and pushes.
