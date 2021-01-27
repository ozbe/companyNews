# Terraform

## Prereqs
* Docker - Tested with `Docker version 20.10.2, build 2291f61`
* Setup GCP Project [Nice tutorial here](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform)
  * Create or choose existing GCP project
    * Mine is `ozbe-companynews`
  * Create or choose existing Service Account (SA) with `Project Owner` role
    * Mine is `terraform@ozbe-companynews.iam.gserviceaccount.com`
  * Create a SA key (json) and save the key in the project directory as `sa-key.json` (don't worry the filename is in the .gitignore)
* **TODO** enable [Cloud Resource Manager API](https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=524336931530&pli=1)
* **TODO** warn about google services being update in GCP Project 
* **TODO** how to setup `tf.vars`
* **IDEA** Support using local gcloud credentials for ease of setup

## Development

```
$ docker build -t tf .
$ docker run \
  --rm \
  -it \
  -v `pwd`:/terraform \
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