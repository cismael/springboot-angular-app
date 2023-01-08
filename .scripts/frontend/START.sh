#!/bin/bash

# Cd to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR || exit 1

# Cd to the parent folder (.scripts) to source needed variables and functions files
cd .. && source source_files

# Then cd to the root folder (parent folder)
cd ..

############################################################################################################### Frontend
# Cd to frontend folder and start it by calling the function
cd ${FRONTEND_FOLDER_NAME} || exit 1 && npm run start:open
