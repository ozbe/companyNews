# Terraform

## Prereqs
* Docker - Tested with `Docker version 20.10.2, build 2291f61`
* Setup Google Cloud Project
* `glcoud` configured to use an account with `Project Owner` permissions to _the_ GCP Project (`project_id`)

## Development

```
$ docker build -t tf .
$ docker run \
  --rm \
  -it \
  -v `pwd`:/terraform \
  tf
```

## Environment tfvars

The steps provided throughout documentation refer to using `training.tfvars` or `production.tfvars`. You will need to create each file. Thankfully `variables.tf` has reasonable defaults, so you only need to set the `project_id` and `env`. 
* `project_id` should be the GCP project you have for this project.
* `env` should be `training` or `production`, but can be _any_ value (assuming it meets the naming limitations in the resources it is used with). 

### Training Example

```
# training.tfvars
project_id   = "ozbe-companynews-training"
env          = "training"
```
 
Now that you've seen an example, go make `training.tfvars` or `production.tfvars`. 

## Workspaces

Terraform Workspaces are used to isolate state. There is a workspace for `training` and `production`.

### Setup
```
$ terraform workspace new training
$ terraform workspace new production
```

### Select
```
$ terraform workspace select <training|production>
```

## Plan
After [selecting](#select) your workspace

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

## References
* https://github.com/hashicorp/terraform/blob/master/Dockerfile
* https://github.com/docker-library/golang/blob/45f79a2f9262a34b31ab4de0ac7e0728e4002a6b/1.15/alpine3.13/Dockerfile