#!/bin/bash

# go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# then go to the root folder (parent folder)
cd ..

# package the helm chart
helm package .k8s/helm-chart/ --destination ./helm-package-output

# Get packed helm chart file name
HELM_PAKAGE_NAME=`ls ./helm-package-output/*.tgz`

# git repository owner name
GIT_REPO_OWNER="cismael"

################################################################################################################# DockerHub
# log into dockerhub container registry
#docker login --username ${GIT_REPO_OWNER} --password-stdin

# push the helm package to dockerhub oci registry
helm push ${HELM_PAKAGE_NAME} oci://registry-1.docker.io/${GIT_REPO_OWNER}

# helm pull
# helm pull oci://registry-1.docker.io/cismael/springboot-angular-app --version 0.1.0

################################################################################################################# Github
# login to github container registry
#docker login ghcr.io --username ${GIT_REPO_OWNER} --password-stdin
#echo ${GITHUB_PAT} | docker login ghcr.io --username ${GIT_REPO_OWNER} --password-stdin

# push the helm package to github oci registry
helm push ${HELM_PAKAGE_NAME} oci://ghcr.io/${GIT_REPO_OWNER}/helm-chart

# helm pull
# helm registry login -u ${GIT_REPO_OWNER} ghcr.io/${GIT_REPO_OWNER}
# helm pull ghcr.io/${GIT_REPO_OWNER}/helm-charts/springboot-angular-app-0.1.0

# delete generated helm package
rm -rf ./helm-package-output
