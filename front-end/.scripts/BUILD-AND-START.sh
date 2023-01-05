#!/bin/bash

# install dependencies
npm install --force

# build
npm run build:dev

# start
npm run start:open
