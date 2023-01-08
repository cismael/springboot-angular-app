#!/bin/bash

# repository owner name
GIT_REPO_OWNER="cismael"

BACKEND_DOCKER_IMAGE_NAME="springboot-angular-app-backend"

FRONTEND_DOCKER_IMAGE_NAME="springboot-angular-app-frontend"

################################################################################################################# Backend
# build the backend
cd back-end
./mvnw clean install -T4
cd users/users-api/

# build backend docker image, tag for local use, tag for dockerhub container registry, tag for github container registry
docker build -f Dockerfile . --tag ${GIT_REPO_OWNER}/${BACKEND_DOCKER_IMAGE_NAME} \
                             --tag ghcr.io/${GIT_REPO_OWNER}/${BACKEND_DOCKER_IMAGE_NAME}

# log into dockerhub container registry
#docker login --username ${GIT_REPO_OWNER} --password-stdin
# push docker image to dockerhub container registry
docker push ${GIT_REPO_OWNER}/$BACKEND_DOCKER_IMAGE_NAME

# log into github container registry
#docker login ghcr.io --username ${GIT_REPO_OWNER} --password-stdin
# push docker image to github container registry
docker push ghcr.io/${GIT_REPO_OWNER}/${BACKEND_DOCKER_IMAGE_NAME}

cd ../../../

################################################################################################################# Frontend
# build, create and tag docker image of the frontend
cd front-end
npm install && npm run build:prod

# build frontend docker image, tag for local use, tag for dockerhub container registry, tag for github container registry
docker build -f Dockerfile . --tag ${GIT_REPO_OWNER}/${FRONTEND_DOCKER_IMAGE_NAME} \
                             --tag ghcr.io/${GIT_REPO_OWNER}/${FRONTEND_DOCKER_IMAGE_NAME}

# log into dockerhub container registry
#docker login --username ${GIT_REPO_OWNER} --password-stdin
# push docker image to dockerhub container registry
docker push ${GIT_REPO_OWNER}/${FRONTEND_DOCKER_IMAGE_NAME}

# log into github container registry
#docker login ghcr.io --username ${GIT_REPO_OWNER} --password-stdin
# push docker image to github container registry
docker push ghcr.io/${GIT_REPO_OWNER}/${FRONTEND_DOCKER_IMAGE_NAME}
