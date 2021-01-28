War 
http://35.201.30.235/SampleWebApp/

```
/bitnami/tomcat/webapps/
/opt/bitnami/tomcat/webapps_default
```

```
$ POD=$(kubectl get pod -l app=company-news -l env=$ENV -o jsonpath="{.items[0].metadata.name}")
$ kubectl exec --stdin --tty $POD -- /bin/bash
/$ cd /app
```