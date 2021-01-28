#!/bin/bash
#
# Upload static assets to GCP
#   Configured to run from project root
#
# Dependencies
#   unzip
#   terraform
#   gsutil
#
# Inputs
#   $1 - env (terraform workspace)
#   $2 - path to zip 
set -e

# Store current terraform workspace
PREV_WS=$(terraform -chdir=terraform workspace show)

# Change terraform workspace
terraform -chdir=terraform workspace select $1

# Get bucket name from terraform
BUCKET=$(terraform -chdir=terraform output company_news_cdn_bucket | tr -d '"')

# Restore terraform workspace
terraform -chdir=terraform workspace select $PREV_WS

# Unzip to tmp
TMP_PATH=/tmp/upload_assets

unzip -o -d $TMP_PATH $2

# Sync tmp to bucket, removing any old files
gsutil rsync -d -r $TMP_PATH gs://$BUCKET

echo 'Success!'