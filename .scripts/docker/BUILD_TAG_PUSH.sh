#!/bin/bash

# Go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# Then go to the root folder (parent folder)
cd ../..

################################################################################################################# Declare needed variables
# Container registry owner name
CONTAINER_REGISTRY_OWNER_USERNAME="cismael"

BACKEND_DOCKER_IMAGE_NAME="springboot-angular-app-backend"

FRONTEND_DOCKER_IMAGE_NAME="springboot-angular-app-frontend"

# DockerHub container registry URL
DOCKERHUB_CONTAINER_REGISTRY_URL="docker.io"
# Dockerhub container registry owner password
DOCKERHUB_CONTAINER_REGISTRY_PASSWORD="YOUR_DOCKERHUB_CONTAINER_REGISTRY_PASSWORD"

# Github container registry URL
GITHUB_CONTAINER_REGISTRY_URL="ghcr.io"
# GitHub container registry owner password
GITHUB_CONTAINER_REGISTRY_PAT="YOUR_GITHUB_CONTAINER_REGISTRY_PAT"

#################################################################################################################
# Function to set the wrapped maven executor compatible for the OS type
function set_wrapped_maven_executor() {
  # Set the wrapped maven executor to use
  if [[  $OSTYPE == "linux-gnu" ]]; then
    echo "===> This is a Linux or WSL Operating System"
    WRAPPED_MAVEN_EXECUTOR="mvnw"
  elif [[ $OSTYPE == "msys" ]]; then
    echo "===> This is a Windows Operating System"
    WRAPPED_MAVEN_EXECUTOR="mvnw.cmd"
  else
    echo "OS ($OSTYPE) not supported"
    exit 1
  fi;
}

#################################################################################################################
# Function to build the backend
function build_backend() {
  # Go the backend folder
  cd back-end || exit 1

  # Call the function that set the maven wrapped executor
  set_wrapped_maven_executor

  # Build the backend
  ./${WRAPPED_MAVEN_EXECUTOR} clean install -T4
}

#################################################################################################################
# Function to build the frontend
function build_frontend() {
  # Go the frontend folder
  cd front-end || exit 1

  # Build the frontend
  npm install && npm run build:prod
}

#################################################################################################################
# Function to build and tag a docker image for local use, DockerHub and GitHub
# - build docker image of the backend
# - tag the docker image for local use
# - tag for docker image DockerHub container registry
# - tag for docker image GitHub container registry
# ===> 1 parameter referring to the docker image name is mandatory
function build_and_tag_docker_images() {
  if [ -z "$1" ] # If the docker image name is not set
    then
      echo "The docker image name is not set" && exit 1
    else
      # Get the docker image name setted via the parameter
      local DOCKER_IMAGE_NAME=$1
  fi

  docker build -f Dockerfile . \
          --tag ${CONTAINER_REGISTRY_OWNER_USERNAME}/${DOCKER_IMAGE_NAME} \
          --tag ${DOCKERHUB_CONTAINER_REGISTRY_URL}/${CONTAINER_REGISTRY_OWNER_USERNAME}/${DOCKER_IMAGE_NAME} \
          --tag ${GITHUB_CONTAINER_REGISTRY_URL}/${CONTAINER_REGISTRY_OWNER_USERNAME}/${DOCKER_IMAGE_NAME}
}

#################################################################################################################
# Function to push the frontend and the backend docker images into a container registry
# Needs 3 parameters ($1, $2 and $3):
# - first  : the container registry url
# - second : the container registry owner username
# - third  : the container registry owner password (can also be a GitHub Personal Access Token "PAT")
function push_docker_images_to_container_registry() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] # If 1 of the 3 parameters is not set
    then
      echo "The container registry url|username|password is not set" && exit 1
    else
      # Get the three parameters
      local CONTAINER_REGISTRY_URL=$1
      local CONTAINER_REGISTRY_OWNER_USERNAME=$2
      local CONTAINER_REGISTRY_PASSWORD=$3
  fi

  # Log in to the container registry
  docker login ${CONTAINER_REGISTRY_URL} --username ${CONTAINER_REGISTRY_OWNER_USERNAME} --password ${CONTAINER_REGISTRY_PASSWORD}

  # Backend
  # Push the backend docker image to the container registry
  docker push ${CONTAINER_REGISTRY_URL}/${CONTAINER_REGISTRY_OWNER_USERNAME}/$BACKEND_DOCKER_IMAGE_NAME

  # Frontend
  # Push the frontend docker image to the container registry
  docker push ${CONTAINER_REGISTRY_URL}/${CONTAINER_REGISTRY_OWNER_USERNAME}/${FRONTEND_DOCKER_IMAGE_NAME}

  # Log out from the container registry
  docker logout ${CONTAINER_REGISTRY_URL}
}

################################################################################################################# Backend
# Build the backend by calling the function that builds it
build_backend

### Go to the users-api folder to build docker image from the Dockerfile
cd users/users-api/ || exit 1

# Build the backend docker images
build_and_tag_docker_images "${BACKEND_DOCKER_IMAGE_NAME}"

# Go back to the root folder again
cd ../../../

################################################################################################################# Frontend
# Build the frontend by calling the function that builds it
build_frontend

# Build the frontend docker images
build_and_tag_docker_images "${FRONTEND_DOCKER_IMAGE_NAME}"

################################################################################################################# Push docker images
# Push frontend and backend docker images to Dockerhub container registry
push_docker_images_to_container_registry "${DOCKERHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER_USERNAME}" "${DOCKERHUB_CONTAINER_REGISTRY_PASSWORD}"

# Push frontend and backend docker images to GitHub container registry
push_docker_images_to_container_registry "${GITHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER_USERNAME}" "${GITHUB_CONTAINER_REGISTRY_PAT}"
