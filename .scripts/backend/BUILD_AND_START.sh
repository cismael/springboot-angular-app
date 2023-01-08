#!/bin/bash

# Go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# Then go to the backend folder
cd ../../back-end || exit 1

# Build the backend
./mvnw clean install

# Start the backend users-api app
./mvnw -f ./users/users-api/ spring-boot:run
