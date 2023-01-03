#!/bin/bash

# repository owner name
REPO_OWNER="cismael"

# build, create and tag docker image of the backend
cd back-end
./mvnw clean install -T4
cd users/users-api/
docker build -f Dockerfile . --tag ${REPO_OWNER}/springboot-angular-app-backend

# push to dockerhub
docker push ${REPO_OWNER}/springboot-angular-app-backend

# tag and push to github container registry
docker tag ${REPO_OWNER}/springboot-angular-app-backend ghcr.io/${REPO_OWNER}/springboot-angular-app-backend
docker push ghcr.io/${REPO_OWNER}/springboot-angular-app-backend

cd ../../../

# build, create and tag docker image of the frontend
cd front-end
npm install && npm run build:prod
docker build -f Dockerfile . --tag ${REPO_OWNER}/springboot-angular-app-frontend

# push to dockerhub
docker push ${REPO_OWNER}/springboot-angular-app-frontend

# tag and push to github container registry
docker tag ${REPO_OWNER}/springboot-angular-app-frontend ghcr.io/${REPO_OWNER}/springboot-angular-app-frontend
docker push ghcr.io/${REPO_OWNER}/springboot-angular-app-frontend
