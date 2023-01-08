#!/bin/bash

# Cd to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR || exit 1

# Cd to the parent folder (.scripts) to source needed variables and functions files
cd .. && source source_files

# Then cd to the root folder (parent folder)
cd ..

########################################################################################################################
# Package the helm chart by calling the function that packages it
package_helm_chart

# Push the packed helm chart to DockerHub
push_packed_helm_chart_to_registry "${DOCKERHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER_USERNAME}" "${DOCKERHUB_CONTAINER_REGISTRY_PASSWORD}"

# Push the packed helm chart to GitHub
push_packed_helm_chart_to_registry "${GITHUB_CONTAINER_REGISTRY_URL}" "${CONTAINER_REGISTRY_OWNER_USERNAME}" "${GITHUB_CONTAINER_REGISTRY_PAT}"

# Delete the generated helm package
rm -rf ${HELM_PACKAGE_OUTPUT_FOLDER}
