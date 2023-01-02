#!/bin/bash

# kubernetes namespace
NAMESPACE="springboot-angular-app"

# clean helm release
helm uninstall springboot-angular-app -n $NAMESPACE

# delete the namespace
kubectl delete namespace $NAMESPACE
