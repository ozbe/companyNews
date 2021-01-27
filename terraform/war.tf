# persistent volume (maybe)

resource "random_password" "tomcat_password" {
  length = 10
}

# helm release
resource "helm_release" "war" {
  name = "company-news"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "tomcat"
  version = "8.1.1"

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set {
    name = "updateStrategy.type"
    value = "Recreate"
  }

  set {
   name = "resources.requests.cpu"
   # Changed from `300m` because the node pool instances are n1-standard-1
   value = "200m"
  }

  set {
    name = "tomcatPassword"
    value = random_password.tomcat_password.result
  }

  set {
    name = "podLabels"
    value = yamlencode({
     "app" = "company-news"
    })
  }
}

# output pod data and ingress