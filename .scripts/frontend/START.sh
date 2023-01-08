#!/bin/bash

# Go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# Then go to the frontend folder
cd ../../front-end || exit 1

# Start the frontend
npm run start:open
