# Troubleshooting

Paths on interest on tomcat
```
/bitnami/tomcat/webapps/
/opt/bitnami/tomcat/webapps_default
```

Remote into web server
```
$ POD=$(kubectl get pod -l app=company-news -l env=$ENV -o jsonpath="{.items[0].metadata.name}")
$ kubectl exec --stdin --tty $POD -- /bin/bash
/$ cd /app
```

Helm release in bad state after destroy
```
$ terraform state rm module.company_news.helm_release.web_server
```