#!/bin/bash

# build
./mvnw clean install

# start the app
./mvnw -f ./users/users-api/ spring-boot:run
