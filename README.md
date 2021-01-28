# companyNews

## Requirements
* Tested on `macOS 11.1 (20C69)`

## Documentation
* [README](/README.md) (this document) - How to run solution
* [Approach Taken](/docs/approach-taken.md) - Response to approach taken
* [Scaling](/docs/scaling.md) - Plan for scaling
* [Monitoring and Alerting](/docs/monitoring-and-alerting.md) - Plan for monitoring and alerting
* [Troubleshooting](/docs/troubleshooting.md) - Dumping ground for troubleshooting commands
* [TODO](/docs/TODO.md) - Progress, planning, notes used throughout solving the problem

## Steps
1. [GCP Project](#gcp-project)
2. [Terraform Setup](#terraform)
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

# Get billing ACCOUNT_ID
$ gcloud alpha billing accounts list

# Enable billing
$ gcloud beta billing projects link <PROJECT_ID> --billing-account=<ACCOUNT_ID>

# Set project
$ gcloud config set project <PROJECT_ID>

# Enable Cloud Resource Manager API
gcloud services enable cloudresourcemanager.googleapis.com
```

### Training Example

```
# Create project
$ gcloud projects create ozbe-cn-training

# Get billing ACCOUNT_ID
$ gcloud alpha billing accounts list

# Enable billing 
$ gcloud alpha billing projects link ozbe-cn-training --billing-account=XXXXXXX

# Set project
$ gcloud config set project ozbe-cn-training

# Enable Cloud Resource Manager API
$ gcloud services enable cloudresourcemanager.googleapis.com
```

### Create Terraform Service Account (SA)

```
# Create SA
$ gcloud iam service-accounts create <SA_NAME> --display-name "Terraform Account"

# Assign SA owner role
$ gcloud projects add-iam-policy-binding <PROJECT_ID> --member "serviceAccount:<SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com" --role "roles/owner"

# Create and download SA key
$ gcloud iam service-accounts keys create <SA_KEY>.json --iam-account <SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com

# Activate service account 
$ gcloud auth activate-service-account --project=<PROJECT_ID> --key-file=<SA_KEY>.json

# Set gcloud account to SA
$ gcloud config set account <SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com

# Login
$ gcloud auth application-default login
```

### Training Example

```
# Create SA
$ gcloud iam service-accounts create terraform --display-name "Terraform Account"

# Assign SA owner role
$ gcloud projects add-iam-policy-binding ozbe-cn-training --member "serviceAccount:terraform@ozbe-cn-training.iam.gserviceaccount.com" --role "roles/owner"

# Create and download SA key
$ gcloud iam service-accounts keys create sa-key.json --iam-account terraform@ozbe-cn-training.iam.gserviceaccount.com

# Activate service account 
$ gcloud auth activate-service-account --project=ozbe-cn-training --key-file=sa-key.json

# Set gcloud account to SA
$ gcloud config set account terraform@ozbe-cn-training.iam.gserviceaccount.com

# Login
$ gcloud auth application-default login
```

## Terraform

Terraform is used to stand up the GCP Project's infrastructure.

Follow the setup and deploy steps in [Terraform Setup](/terraform/README.md#setup-and-deploy) to setup the `training` envrionment. 

Don't forget to `cd ./terraform` from the project root for the terraform setup!

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
$ ZONE=$(terraform -chdir=./terraform output zone | tr -d '"')
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

#### Training example
```
$ ./scripts/upload_static_assets.sh training ./tests/assets/static-assets/archive.zip
```

### War

Deploy `war file with the dynamic parts of the application`

```
$ ./scripts/upload_war.sh <training|production> <PATH_TO_WAR>
```

#### Training example
```
$ ./scripts/upload_war.sh training ./tests/assets/war/SampleWebApp.war
```

## View

### View Static Assets

```
$ ./scripts/view_static_assets.sh
```

### View WAR

```
$ ./scripts/view_war.sh
```

## Production
You have a one of two choices for testing Production environment. You can follow all of the directions starting from [GCP Project](#gcp-project), where you setup a new GCP project, *or* you can go through the [Clean up](#clean-up) and then start at the [Terraform](#terraform) setup.

## Clean up
Now to undo everything we did.

### Terraform Destroy

See the [terraform/README.md](/terraform/README.md#destroy) for info on how to destroy the resources.

### Remove kubectl context

```
$ kubectl config delete-context <KUBE_CONTEXT>
```

### Remove service account

```
# List accounts
$ gcloud auth list

# Switch account to one other than SA
$ gcloud config set account <ACCOUNT>

# Revoke SA account
$ gcloud revoke <SA_ACCOUNT>
```

### Training Example

```
# List accounts
$ gcloud auth list

# Switch account to one other than SA
$ gcloud config set account XXXXX@gmail.com 

# Revoke SA account
$ gcloud revoke terraform@ozbe-cn-training.iam.gserviceaccount.com
```

### Delete project

```
gcloud projects delete <PROJECT_ID>
```

```
gcloud projects delete ozbe-cn-training
```

### Treat yourself

You're done. Take a break. Treat yourself.