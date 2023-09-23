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
check_if_an_env_name_is_provided "Which environment would you want to stop using helm ? (dev|staging|prod) : " "$@"

# Check the provided environment name by calling the function
check_provided_env_name

# Identify the kubernetes namespace in which to stop the environment by calling the function
identify_the_kubernetes_namespace_to_delete

# Uninstall the helm release if it exists
uninstall_helm_release

# Delete the kubernetes namespace
kubectl delete namespace $K8S_NAMESPACE
