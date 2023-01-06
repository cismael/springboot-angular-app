#!/bin/bash

# kubernetes namespace
NAMESPACE="springboot-angular-app"

# clean up helm release in staging environment
helm uninstall staging-springboot-angular-app -n $NAMESPACE

# delete the namespace
kubectl delete namespace $NAMESPACE
