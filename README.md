# companyNews

Progress and planning can be found in [TODO.md](/TODO.md)

## Steps
1. [GCP Project](/#gcp-project)
2. [Terraform Setup](/#terraform)
3. [kubectl](#kubectl)
4. [Deploy Developer Assets](#deploy-developer-assets)
5. [View assets](#view-assets)

## GCP Project
... and service account

We need a GCP Project and Service Account with the Project Owner role. 

You may already a project and SA account already, but these directions will assume that you are starting from scratch.

### Create GCP Project

```
# Create project
$ gcloud projects create <PROJECT_ID>
# Set project
$ gcloud config set project <PROJECT_ID>
# Enable Cloud Resource Manager API
gcloud services enable "cloudresourcemanager.googleapis.com"
```

### Create Terraform Service Account (SA)

```
# Create SA
$ gcloud iam service-accounts create <SA_NAME>  --display-name "Terraform Account"
# Assign SA owner role
$ gcloud projects add-iam-policy-binding <PROJECT_ID> --member "<SA_NAME:<PROJECT_ID>@someproject.iam.gserviceaccount.com" --role "roles/owner"
# Create and download SA key
$ gcloud iam service-accounts keys create <SA_KEY>.json \
  --iam-account <SA_NAME>m@<PROJECT_ID>.iam.gserviceaccount.com
# Activate service account 
$ gcloud auth activate-service-account --project=<PROJECT_ID> --key-file=<SA_KEY>.json
# Set gcloud account to SA
$ gcloud config set account gcpcmdline@someproject.iam.gserviceaccount.com
# Login to SA
$ gcloud auth application-default login --no-launch-browser
```

## Terraform

Terraform is used to stand up the GCP Project's infrastructure.

Follow the steps in [Terraform Setup](/terraform/README.md) to setup the `training` envrionment. 

We will talk about [production](#production) later.

## kubectl

`kubectl` is used for deploying and viewing the WAR assets.

```
$ terraform -chdir=./terraform workspace select <training|production>
$ GKE_NAME=$(terraform -chdir=./terraform output gke_name | tr -d '"')
$ ZONE=$(terraform -chdir=./terraform output zone | tr -d '"')
$ gcloud container clusters get-credentials --zone=$ZONE $GKE_NAME
```

### Training example
```
$ terraform -chdir=./terraform workspace select training
$ GKE_NAME=$(terraform -chdir=./terraform output gke_name | tr -d '"')
$ REGION=$(terraform -chdir=./terraform output zone | tr -d '"')
$ gcloud container clusters get-credentials --zone=$ZONE $GKE_NAME
```

## Deploy Developer Assets

Copy assets, after deploying terraform environments and setting up `kubectl`.

These scripts are meant to used when the developers give us their CI build artifacts for deployment. Ideally these scripts would be part of the developers' CI (or another CI) that uses a Service account with the appropriate permissions.

### Static Assets

Deploy `.zip file with the image and stylesheet used for the application`

```
$ ./scripts/upload_static_assets.sh <training|production> <PATH_TO_ASSETS_ZIP>
```

### Training example
```
$ ./scripts/upload_static_assets.sh training ./tests/assets/static-assets/archive.zip
```

### War

Deploy `war file with the dynamic parts of the application`

```
$ ./scripts/upload_war.sh <training|production> <PATH_TO_WAR>
```

### Training example
```
$ ./scripts/upload_war.sh training ./tests/assets/war/SampleWebApp.war
```

## View

### View Static Assets
**TODO** Expose lb ip in output


### View WAR
```
$ SVC_IP=$(kubectl get svc company-news-tomcat -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
$ open "http://$SVC_IP/SampleWebApp/"
```

## Production
**TODO**

## Clean up
**TODO**
terraform destroy
remove service account
remove kubectl context
delete project