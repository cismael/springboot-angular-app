#!/bin/bash

# go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# then go to the root folder (parent folder)
cd ..

# package the helm chart
helm package .k8s/helm-chart/ --destination ./helm-package-output

# Get packed chart file name
HELM_PAKAGE_NAME=`ls ./helm-package-output/*.tgz`

# repository owner name
REPO_OWNER="cismael"

################################################################################################################# DockerHub
# push the helm chart to dockerhub
helm push ${HELM_PAKAGE_NAME} oci://registry-1.docker.io/${REPO_OWNER}

# helm pull
# helm pull oci://registry-1.docker.io/cismael/springboot-angular-app --version 0.1.0
################################################################################################################# Github
# login to github
echo $GITHUB_TOKEN | docker login ghcr.io --username ${REPO_OWNER} --password-stdin

# push the helm chart to github
helm push ${HELM_PAKAGE_NAME} oci://ghcr.io/${REPO_OWNER}/charts

# log into github container registry
# docker login ghcr.io/${REPO_OWNER}

# helm pull ghcr.io/${REPO_OWNER}/charts/springboot-angular-app-0.1.0
# helm registry login -u ${REPO_OWNER} ghcr.io/${REPO_OWNER}
