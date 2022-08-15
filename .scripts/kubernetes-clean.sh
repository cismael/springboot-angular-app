#!/bin/bash

# create the namespace
kubectl delete namespace springboot-angular-app

# clean through helm
helm uninstall myapp
