# Terraform

## Prereqs
* Docker - Tested with `Docker version 20.10.2, build 2291f61`
* Setup GCP Project [Nice tutorial here](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform)
  * Create or choose existing GCP project
    * Mine is `ozbe-companynews`
  * Create or choose existing Service Account (SA) with `Project Owner` role
    * Mine is `terraform@ozbe-companynews.iam.gserviceaccount.com`
  * Create a SA key (json) and save the key in the project directory as `sa-key.json` (don't worry the filename is in the .gitignore)
* **TODO** how to setup `tf.vars`

## Development

```
$ docker build -t tf .
$ docker run \
  --rm \
  -it \
  -v `pwd`/terraform:/terraform \
  tf
```

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

## References
* https://github.com/hashicorp/terraform/blob/master/Dockerfile
* https://github.com/docker-library/golang/blob/45f79a2f9262a34b31ab4de0ac7e0728e4002a6b/1.15/alpine3.13/Dockerfile