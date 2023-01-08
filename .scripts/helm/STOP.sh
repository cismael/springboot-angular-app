#!/bin/bash

################################################################################################################# Declare needed variables
# Possible environment values
ENVIRONMENTS="dev staging prod"

#################################################################################################################
# Function to check if the environment name to deploy is provided. If not ask for it.
function check_if_an_env_name_is_provided() {
  if [ -z "$1" ]
    then
      read -p "Which environment would you want to stop using helm ? (possible values are : dev|staging|prod) : " ENV_TO_DEPLOY
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
# Function to get the kubernetes namespace based on the environment name to stop
function identify_the_kubernetes_namespace_to_delete() {
  if [ "$ENV_TO_DEPLOY" == "dev" ] || [ "$ENV_TO_DEPLOY" == "staging" ]
    then K8S_NAMESPACE="springboot-angular-app"
  elif [ "$ENV_TO_DEPLOY" == "prod" ]
    then K8S_NAMESPACE="prod-springboot-angular-app"
  fi
}

#################################################################################################################
# Function to uninstall the helm release if it exists
function uninstall_helm_release() {
  # Check if the helm release exists
  DOES_THE_HELM_RELEASE_EXISTS=$(helm status ${ENV_TO_DEPLOY}-springboot-angular-app -n $K8S_NAMESPACE)

  if [ ! -z "$DOES_THE_HELM_RELEASE_EXISTS" ]
    then
      # Clean up the provided environment helm release
      helm uninstall ${ENV_TO_DEPLOY}-springboot-angular-app -n $K8S_NAMESPACE
    else
      echo "===> There is no helm release installed into the provided environment name" && exit 1 # with this exit statement the script stops
  fi
}

#################################################################################################################
# Check if an environment name is provided by calling the function
check_if_an_env_name_is_provided "$@"

# Check the provided environment name by calling the function
check_provided_env_name

# Identify the kubernetes namespace in which to stop the environment by calling the function
identify_the_kubernetes_namespace_to_delete

# Uninstall the helm release if it exists
uninstall_helm_release

# Delete the kubernetes namespace
kubectl delete namespace $K8S_NAMESPACE
