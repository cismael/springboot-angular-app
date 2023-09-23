#!/bin/bash

# Cd to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR || exit 1

# Cd to the parent folder (.scripts) to source needed variables and functions files
cd .. && source source_files

# Then cd to the root folder (parent folder)
cd ..

########################################################################################################################
# Check if an environment name is provided by calling the function
check_if_an_env_name_is_provided "Which environment would you want to deploy using helm ? (dev|staging|prod) : " "$@"

# Check the provided environment name by calling the function
check_provided_env_name

# Create the kubernetes namespace by calling the function
create_kubernetes_namespace

# Deploy environment with helm
helm upgrade --install ${ENV_TO_DEPLOY}-springboot-angular-app $HELM_CHART_DIR --values $HELM_CHART_DIR/values/values.${ENV_TO_DEPLOY}.yaml -n $K8S_NAMESPACE

# Wait for the frontend to be up and running to port-forward
kubectl -n $K8S_NAMESPACE wait deployment ${ENV_TO_DEPLOY}-springboot-angular-app-frontend-deployment --for condition=Available=True --timeout=30s

# Wait for the backend to be up and running to port-forward
kubectl -n $K8S_NAMESPACE wait deployment ${ENV_TO_DEPLOY}-springboot-angular-app-backend-deployment --for condition=Available=True --timeout=90s

# Set the frontend port number to use for kubectl port forward on localhost
set_frontend_port_number_for_port_forward

# Port-forward in the background for frontend to use at localhost
#kubectl -n $K8S_NAMESPACE port-forward deploy/${ENV_TO_DEPLOY}-springboot-angular-app-frontend-deployment ${FRONTEND_PORT_NUMBER}:80 & \

# Port-forward in the background for backend to use at localhost
#kubectl -n $K8S_NAMESPACE port-forward deploy/${ENV_TO_DEPLOY}-springboot-angular-app-backend-deployment 8081:8081 & \

echo "the frontend is available here : http://localhost:${FRONTEND_PORT_NUMBER}/"
