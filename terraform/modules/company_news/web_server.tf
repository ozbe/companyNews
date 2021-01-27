# NOTE - Consider moving this to variables or password provider
resource "random_password" "web_server" {
  length = 10
}

resource "helm_release" "web_server" {
  name = "company-news"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "tomcat"
  version = "8.1.1"

  # NOTE - This could be changed to RollingUpdate (default) if 
  #   1) If multi-write were supported by the services (in which case `persistence.accessMode` would need udpated)
  #   2) The node resources were increased by changing the node pool machine type
  set {
    name = "updateStrategy.type"
    value = "Recreate"
  }

  # NOTE - Changed from `300m` because the node pool instances are n1-standard-1
  set {
   name = "resources.requests.cpu"
   value = "200m"
  }

  # NOTE - Required to apply updates
  set {
    name = "tomcatPassword"
    value = random_password.web_server.result
  }

  # NOTE - `app` label used to retrieve pod
  set {
    name = "podLabels"
    value = yamlencode({
     "app" = "company-news"
     "env" = var.env
    })
  }
}