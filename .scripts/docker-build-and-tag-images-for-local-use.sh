#!/bin/bash

# build, create and tag docker image of the backend
cd back-end
./mvnw clean install -T4
cd users/users-api/
docker build -f Dockerfile . --tag cismael/springboot-angular-app-backend

cd ../../../

# build, create and tag docker image of the frontend
cd front-end
npm install && npm run build:prod
docker build -f Dockerfile . --tag cismael/springboot-angular-app-frontend
