# TODO

Overview
- [ ] [Terraform](#terraform)
- [ ] [Static Assets](#static-assets)
- [ ] [WAR](#war)
- [ ] [Documentation](#documentation)

## Terraform
**TODO**

### Requirements
* Infrastructure uses Terraform
* Others to be able to build environment
* Training and Production environment
* Production setup for limited release

### Plan
* Create terraform project using workspaces and separate (training & production) tfvars files
* Create and document setting up terraform for gcp
* Create container for running terraform
  * Avoid mismatched dependencies
  * Reproducability

## Static Assets

### Inputs
* A .zip file with the image and stylesheet used for the application

### Requirements
* Deploy the static assets to a web server

### Plan
* Store static assets in GCS
  * Why? - Cost, ease, versioning (if that is implemented)
* Serve static assets via LoadBalancer
  * Why? - While not `a web server`, this does solve the problem of serving the assets, without the overhead of having to manage a web server

### Steps
* Create Service Account with write permissions to CDN bucket
* Create CDN GCS bucket
* Create Load Balancer (CDN)
* Create upload script

## WAR

### Outstanding questions
1. How do I test w/o a war file?

### Inputs
* A .war file with the dynamic parts of the application

### Requirements
* Deploy the .war file to an application server seperate from the static assets
* The app persists data to a file via prevayler

### Plan
* Run WAR file in tomcat helm
  * Why - 
* Run tomcat on GKE
  * Why - 
* Store WAR on GCE persistent volume
  * Why - ease, cost can deploy via kubectl
* Persist prevaylor on GCE persistent volume
  * Why 
    * Pods are ephemeral
    * Persists prevaylor file between pod restarts
* Run GKE with one one node
  * Why - limited release, (personal) cost, prevaylor volume can only be written to by one pod
* Runbook?

### Alternatives
* [Cloud Storage FUSE](https://cloud.google.com/storage/docs/gcs-fuse) for WAR
  * Con: Requires `privileged` https://github.com/maciekrb/gcs-fuse-sample
* GCE persistent disk for prevayler data
  * Speed, cost
* Package WAR in Docker Image

### References
- [Storage options](https://cloud.google.com/compute/docs/disks/)

### Steps
* Create GKE
* Deploy tomact helm to GKE
  * Provide war and prevaylor path in config
  * Enable ingress
  * Persistent volume
* Create upload script

## Documentation
**TODO***

### Requirements
* The ability for us to build your environments, in scripts and/or documentation 
* Links to any images needed to build your environments. 
* A plan for scaling the public release including hardware and software implications. This can include documents, diagrams and/or configuration scripts. If you see any issues scaling this application tell us about it and suggestions, you have for resolving the issues. 
* A paper based description on how monitoring would be implemented
* A narrative of the approach taken. 
  * What principles did you apply?
  * Explanation of the decisions you made and why.
  * What end state do you envision (if you run out of time to implement)?
  * Why were certain tools selected?
  * Why you configured the tools as you did? 
  * What is your recommendation for future work if time allows? 


### Plan
* Put setup and run in README.md
* Put development in separate doc

### Shortcomings with solution
* Deployment of assets are not atomic
* No rolling deploy of WAR
* No versioning
* No rollback strategy
* No HTTPS

### Improvements
* Store terraform state in GCS or use TFE
* Move from prevayler to data storage option appropriate for companyNews use case
  * can still support prevayler localy for development by adding an interface to abstract the data storage
  * **TODO** provide decision tree for choosing storage option
  * world wide and sub second response (spanner) or perhaps use cloud sql with memory store
  * mention leader election alternative?
* Containerize war with tomcat, publish to GCR, and deploy helm specific for companyNews
  * proper health check
  * following deploys
  * versions 
* Fix non-atomic, Deploy assets to different folders (paths) in a bucket and point to said folder from the newly released 
* Support HTTPS
* GKE multi-zone
* Scaling pods