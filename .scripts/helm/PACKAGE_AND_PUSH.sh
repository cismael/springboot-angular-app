#!/bin/bash

# Go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# Then go to the root folder (parent folder) to package the helm chart
cd ../..

################################################################################################################# Declare needed variables
# Container registry owner username
CONTAINER_REGISTRY_OWNER="cismael"

# DockerHub container registry owner password
DOCKERHUB_CONTAINER_REGISTRY_PASSWORD="YOUR_DOCKERHUB_CONTAINER_REGISTRY_PASSWORD"
# DockerHub container registry URL
DOCKERHUB_CONTAINER_REGISTRY_URL="registry-1.docker.io"

# Github container registry owner password
GITHUB_CONTAINER_REGISTRY_PAT="YOUR_GITHUB_CONTAINER_REGISTRY_PAT"
# Github container registry URL
GITHUB_CONTAINER_REGISTRY_URL="ghcr.io"

#################################################################################################################
# Function to package helm chart
function package_helm_chart() {
  HELM_PACKAGE_OUTPUT_FOLDER="helm-package-output"

  # Package the helm chart
  helm package .k8s/helm-chart/ --destination ./${HELM_PACKAGE_OUTPUT_FOLDER}

  # Get packed helm chart file name
  HELM_PAKAGE_NAME=`ls ./${HELM_PACKAGE_OUTPUT_FOLDER}/*.tgz`

  echo "helm package name = '${HELM_PAKAGE_NAME}'"
}

#################################################################################################################
# Function to push packed helm chart to a compatible OCI container registry
# Needs 3 parameters ($1, $2 and $3):
# - first  : the container registry url
# - second : the container registry owner username
# - third  : the container registry owner password (can also be a GitHub Personal Access Token "PAT")
function push_packed_helm_chart_to_registry() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] # If 1 of the 3 parameters is not set
    then
      echo "The OCI container registry url|username|password is not set" && exit 1
    else
      # Get the three parameters
      local CONTAINER_REGISTRY_URL=$1
      local CONTAINER_REGISTRY_OWNER_USERNAME=$2
      local CONTAINER_REGISTRY_PASSWORD=$3
  fi

  # Log in to the OCI container registry
  helm registry login ${CONTAINER_REGISTRY_URL} --username ${CONTAINER_REGISTRY_OWNER_USERNAME} --password ${CONTAINER_REGISTRY_PASSWORD}

  # If the OCI container registry is GitHub then add a prefix to the helm chart name
  if [ "${CONTAINER_REGISTRY_URL}" == "ghcr.io" ]
    then
      local TEMP_CONTAINER_REGISTRY_PATH="${CONTAINER_REGISTRY_OWNER_USERNAME}/helm-chart"
    else
      local TEMP_CONTAINER_REGISTRY_PATH="${CONTAINER_REGISTRY_OWNER_USERNAME}"
  fi

  # Push the helm package to the OCI container registry
  helm push ${HELM_PAKAGE_NAME} oci://${CONTAINER_REGISTRY_URL}/${TEMP_CONTAINER_REGISTRY_PATH}

  # Helm pull example
  # helm pull oci://${CONTAINER_REGISTRY_URL}/${CONTAINER_REGISTRY_OWNER_USERNAME}/${HELM_PAKAGE_NAME} --version 0.1.4

  # Log out from the OCI container registry
  helm registry logout ${CONTAINER_REGISTRY_URL}
}

# Package the helm chart by calling the function that packages it
package_helm_chart

# Push the packed helm chart to DockerHub
push_packed_helm_chart_to_registry "${DOCKERHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER}" "${DOCKERHUB_CONTAINER_REGISTRY_PASSWORD}"

# Push the packed helm chart to GitHub
push_packed_helm_chart_to_registry "${GITHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER}" "${GITHUB_CONTAINER_REGISTRY_PAT}"

# Delete the generated helm package
rm -rf ${HELM_PACKAGE_OUTPUT_FOLDER}
