# Terraform

## Prereqs
* Docker - Tested with `Docker version 20.10.2, build 2291f61`
* Setup Google Cloud Project
* `glcoud` configured to use an account with `Project Owner` permissions to _the_ GCP Project (`project_id`)

## Setup and Deploy
1. [terraform init](#terraform-init)
1. [Environment tfvars](#environment-tfvars)
2. [Workspaces](#workspaces)
3. [Plan](#plan)
4. [Deploy](#deploy)

## Terraform init

```
$ terraform init
```

## Environment tfvars

The steps provided throughout documentation refer to using `training.tfvars` or `production.tfvars`. You will need to create each file. 

Thankfully `variables.tf` has reasonable defaults, so you only **need** to set the `project_id`:
* `project_id` should be the GCP project you have for this project.

### Training Example

```
# training.tfvars
project_id   = "ozbe-cn-training"
```
 
Now that you've seen an example, go make `training.tfvars` and/or `production.tfvars`. 

## Workspaces

Terraform Workspaces are used to isolate state. There is a workspace for `training` and `production`.

### Setup
```
$ terraform workspace new <training|production>
```

### Training Example
```
$ terraform workspace new training
```

### Select
You use select to change workspaces. When you create a new workspace it is automatcially selected. If you're following along, you shouldn't have to run the command, but you may need it later.

```
$ terraform workspace select <training|production>
```

### Training Example
```
$ terraform workspace select training
```

## Plan
After [selecting](#select) your workspace, plan

```
$ terraform plan -out=<training|production>_plan -var-file=<training|production>.tfvars
```

### Training example
```
$ terraform plan -out=training_plan -var-file=training.tfvars
```

## Apply

After [selecting](#select) your workspace and running [plan](#plan)
```
$ terraform apply "<training|production>_plan""
```

### Training example
```
$ terraform apply "training_plan"
```

## Destroy
After [selecting](#select) your workspace
```
$ terraform destroy -var-file=<training|production>.tfvars
```

### Training example
```
$ terraform destroy -var-file=training.tfvars
```

## Development

```
$ docker build -t tf .
$ docker run \
  --rm \
  -it \
  -v `pwd`:/terraform \
  tf
```

## References
* https://github.com/hashicorp/terraform/blob/master/Dockerfile
* https://github.com/docker-library/golang/blob/45f79a2f9262a34b31ab4de0ac7e0728e4002a6b/1.15/alpine3.13/Dockerfile