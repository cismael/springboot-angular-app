#!/bin/bash

# build, create and tag docker images
#./docker-build-and-tag-images-for-local-use.sh

# Go to the script folder (useful if the script is launched from a different folder)
SCRIPT_DIR="$(dirname $(realpath $0))"
cd $SCRIPT_DIR

# Then go to the root folder (parent folder)
cd ../..

################################################################################################################# Declare needed variables
# Possible environment values
ENVIRONMENTS="dev staging prod"

# Helm chart directory path
HELM_CHART_DIR=".k8s/helm-chart"

#################################################################################################################
# Function to check if the environment name to deploy is provided. If not ask for it.
function check_if_an_env_name_is_provided() {
  if [ -z "$1" ]
    then
      read -p "Which environment would you want to deploy using helm ? (possible values are : dev|staging|prod) : " ENV_TO_DEPLOY
    else
      ENV_TO_DEPLOY=$1
  fi
}

#################################################################################################################
# Function to check if the provided environment name is ok
function check_provided_env_name() {
  for env in $ENVIRONMENTS; do
    if [ "$env" == "$ENV_TO_DEPLOY" ]
      then
        echo "===> ${ENV_TO_DEPLOY} is Know environment" && return 0 # with this return statement the script continues
    fi
  done

  echo "===> Unknown environment" && exit 1 # with this exit statement the script stops
}

#################################################################################################################
# Function to create the kubernetes namespace based on the environment name to deploy
function create_kubernetes_namespace() {
  if [ "$ENV_TO_DEPLOY" == "dev" ] || [ "$ENV_TO_DEPLOY" == "staging" ]
    then K8S_NAMESPACE="springboot-angular-app"
  elif [ "$ENV_TO_DEPLOY" == "prod" ]
    then K8S_NAMESPACE="prod-springboot-angular-app"
  fi

  # Create the kubernetes namespace
  kubectl create namespace ${K8S_NAMESPACE}
}

#################################################################################################################
# Function to set the frontend port number to use for kubectl port forward on localhost
function set_frontend_port_number_for_port_forward() {
  if [ "$ENV_TO_DEPLOY" == "dev" ]
    then FRONTEND_PORT_NUMBER=4200
  elif [ "$ENV_TO_DEPLOY" == "staging" ]
    then FRONTEND_PORT_NUMBER=4300
  elif [ "$ENV_TO_DEPLOY" == "prod" ]
    then FRONTEND_PORT_NUMBER=4400
  fi
}

#################################################################################################################
# Check if an environment name is provided by calling the function
check_if_an_env_name_is_provided "$@"

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
kubectl -n $K8S_NAMESPACE port-forward deploy/${ENV_TO_DEPLOY}-springboot-angular-app-frontend-deployment ${FRONTEND_PORT_NUMBER}:80 & \

# Port-forward in the background for backend to use at localhost
kubectl -n $K8S_NAMESPACE port-forward deploy/${ENV_TO_DEPLOY}-springboot-angular-app-backend-deployment 8081:8081 & \

echo "the frontend is available here : http://localhost:${FRONTEND_PORT_NUMBER}/"
