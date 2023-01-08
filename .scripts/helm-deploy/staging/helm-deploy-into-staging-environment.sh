#!/bin/bash

# build, create and tag docker images
#./docker-build-and-tag-images-for-local-use.sh

# go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# then go to the root folder (parent folder)
cd ../../..

# kubernetes namespace
NAMESPACE="springboot-angular-app"

# helm chart directory path
HELM_CHART_DIR=".k8s/helm-chart"

# create the namespace
kubectl create namespace $NAMESPACE

# deploy staging environment with helm
helm upgrade --install staging-springboot-angular-app $HELM_CHART_DIR --values $HELM_CHART_DIR/values/values.staging.yaml -n $NAMESPACE

# wait for the frontend to be up and running to port-forward
kubectl -n $NAMESPACE wait deployment staging-springboot-angular-app-frontend-deployment --for condition=Available=True --timeout=30s

# wait for the backend to be up and running to port-forward
kubectl -n $NAMESPACE wait deployment staging-springboot-angular-app-backend-deployment --for condition=Available=True --timeout=90s

FRONTEND_PORT_NUMBER="4300"

# port-forward into the background for frontend to use at localhost
kubectl -n $NAMESPACE port-forward deploy/staging-springboot-angular-app-frontend-deployment ${FRONTEND_PORT_NUMBER}:80 & \

# port-forward into the background for backend to use at localhost
kubectl -n $NAMESPACE port-forward deploy/staging-springboot-angular-app-backend-deployment 8081:8081 & \

echo "the frontend is available here : http://localhost:${FRONTEND_PORT_NUMBER}/"
