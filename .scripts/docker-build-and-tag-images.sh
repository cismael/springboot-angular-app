#!/bin/bash

# build, create and tag docker image of the backend
cd back-end
mvn clean install
docker build -f users/users-api/Dockerfile . --tag springboot-angular-app-back-end

cd ..

# build, create and tag docker image of the frontend
cd front-end
npm install && npm run build
docker build -f Dockerfile . --tag springboot-angular-app-front-end
