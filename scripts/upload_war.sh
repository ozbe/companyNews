#!/bin/bash
#
# Upload war to pod
#   Configured to run from project root
#
# Dependencies
#   terraform
#   kubectl
#
# Inputs
#   $1 - env (terraform workspace)
#   $2 - path to war 
set -e

ENV=$1
WAR_PATH=$2

# Store current terraform workspace
PREV_WS=$(terraform -chdir=../terraform workspace show)

# Change terraform workspace
terraform -chdir=../terraform workspace select $ENV

# Get gke name from terraform
GKE_NAME=$(terraform -chdir=../terraform output gke_name)

# Restore terraform workspace
terraform -chdir=../terraform workspace select $PREV_WS

# Get config name for env
KC=$(kubectl config view | awk "{if (\$3 ~ /$GKE_NAME$/) print \$3 }")

# Store current kubectl config
PREV_KC=$(kubectl config current-context)

# Change kubectl config
kubectl config use-context $KC

# Get pod name
POD=$(kubectl get pod -l app=company-news -o jsonpath="{.items[0].metadata.name}")

# Copy war to pod
kubectl cp $WAR_PATH $POD:/app

# Restore kubectl workspace
kubectl config use-context $PREV_KC
