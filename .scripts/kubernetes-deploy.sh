#!/bin/bash

# build, create and tag docker images
./docker-build-and-tag-images.sh

# go to the root folder
cd ..

# create the namespace
kubectl create namespace springboot-angular-app

# deploy through helm
helm upgrade --install myapp ./.k8s/helm-chart/ -f ./.k8s/helm-chart/values/values.dev.yaml
