# companyNews

Progress and planning can be found in [TODO.md](/TODO.md)

## Steps
1. [Terraform Setup](/#terraform)
2. [Kubernetes](#kubernetes)
2. [Copy assets](#copy-assets)
3. [View assets](#view-assets)

### Terraform

[Terraform Setup](/terraform/README.md)

### Kubernetes

```
$ terraform -chdir=./terraform workspace select <training|production>
$ GKE_NAME=$(terraform -chdir=./terraform output gke_name)
$ REGION=$(terraform -chdir=./terraform output region)
$ gcloud --region=$REGION container clusters get-credentials $GKE_NAME
```

## Copy Assets

Copy assets, after deploying terraform environments and setting up `kubectl`.

### Static Assets

```
$ ./scripts/upload_static_assets.sh <training|production> <PATH_TO_ASSETS_ZIP>
```

### War

```
$ ./scripts/upload_war.sh <training|production> <PATH_TO_WAR>
```

## View

**TODO** view assets
```
open http://<IP>/SampleWebApp/SnoopServlet
```

**TODO**
```
$ POD=$(kubectl get pod -l app=company-news -o jsonpath="{.items[0].metadata.name}")
$ kubectl cp ./tests/assets/war/SampleWebApp.war $POD:/app
```

$ SVC_IP=$(kubectl get svc company-news-tomcat -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
$ open "http://$SVC_IP/SampleWebApp/"

http://35.201.30.235/SampleWebApp/

```
/bitnami/tomcat/webapps/
/opt/bitnami/tomcat/webapps_default
```

```
kubectl exec --stdin --tty company-news-tomcat-75645b7b86-rjmlk -- /bin/bash
/ cd /bitnami/tomcat
```