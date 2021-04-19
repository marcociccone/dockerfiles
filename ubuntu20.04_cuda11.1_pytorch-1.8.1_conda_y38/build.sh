#!/bin/bash

# IMAGE_NAME="${USER}/dl:cuda10.1_pytorch-1.4_tf-1.15_py36"
IMAGE_NAME="${USER}/dl:cuda11.1_pytorch-1.8.1_conda_py38"
echo "Building Dockerfile with image name: ${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} .
