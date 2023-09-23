#!/bin/bash

# Cd to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR || exit 1

# Cd to the parent folder (.scripts) to source needed variables and functions files
cd .. && source source_files

# Then cd to the root folder (parent folder)
cd ..

################################################################################################################ Backend
# Ask and build the backend if needed
ask_if_build_is_needed "${BACKEND_FOLDER_NAME}"

# Build the backend docker images
build_and_tag_docker_images "${BACKEND_DOCKER_IMAGE_NAME}"

## Go back to the root folder again
cd ../../../

############################################################################################################### Frontend
# Ask and build the frontend if needed
ask_if_build_is_needed "${FRONTEND_FOLDER_NAME}"

# Build the frontend docker images
build_and_tag_docker_images "${FRONTEND_DOCKER_IMAGE_NAME}"

##################################################################################################### Push docker images
# Push frontend and backend docker images to Dockerhub container registry
push_docker_images_to_container_registry "${DOCKERHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER_USERNAME}" "${DOCKERHUB_CONTAINER_REGISTRY_PASSWORD}"

# Push frontend and backend docker images to GitHub container registry
push_docker_images_to_container_registry "${GITHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER_USERNAME}" "${GITHUB_CONTAINER_REGISTRY_PAT}"
