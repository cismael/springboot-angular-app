#!/bin/bash

# kubernetes namespace
NAMESPACE="springboot-angular-app-prod"

# clean up helm release in prod environment
helm uninstall prod-springboot-angular-app -n $NAMESPACE

# delete the namespace
kubectl delete namespace $NAMESPACE
