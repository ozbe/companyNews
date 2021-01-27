# companyNews

Progress and planning can be found in [TODO.md](/TODO.md)

## Steps
1. [Terraform Setup](/terraform/README.md)
2. [Copy assets](#copy-assets)

## Kubernetes

**TODO** requires `gcloud config set compute/zone australia-southeast1-b`
`$ gcloud container clusters get-credentials $(terraform output gke_name)`

## Copy Assets

### Static Assets
**TODO** gsutil setup
```
gsutil rsync -d -r ./tests/assets/static-assets/ gs://ozbe-companynews-static_assets-training/
```
**TODO** get ip:port for `static-assets-url-map` via glcoud

### War

```
company-news-tomcat-897f447d-n9zm9
```

## View

**TODO** view assets
```
open http://<IP>/SampleWebApp/SnoopServlet
```

**TODO**
```
kubectl get pods -l app=company-news
kubectl cp ./tests/assets/ company-news-tomcat-75645b7b86-rjmlk:/
```