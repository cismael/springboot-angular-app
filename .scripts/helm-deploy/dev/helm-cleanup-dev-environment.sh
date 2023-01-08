#!/bin/bash

# kubernetes namespace
NAMESPACE="springboot-angular-app"

# clean up helm release in dev environment
helm uninstall dev-springboot-angular-app -n $NAMESPACE

# delete the namespace
kubectl delete namespace $NAMESPACE
