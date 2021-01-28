# [OBSOLETE] TODO

Overview
- [/] [Terraform](#terraform)
- [/] [Static Assets](#static-assets)
- [/] [WAR](#war)
- [/] [Documentation](#documentation)

## Terraform

### Requirements
* Infrastructure uses Terraform
* Others to be able to build environment
* Training and Production environment
* Production setup for limited release

### Plan
* Terraform project using workspaces and separate (training & production) tfvars files
* Create and document setting up terraform for gcp
* Create container for running terraform
  * Avoid mismatched dependencies
  * Reproducability

### Steps
- [x] Setup gcp project (1)
- [x] Setup test (2)
- [ ] Setup production variables

## Static Assets

### Outstanding questions
1. Does the cache work in a desirable way (ex: will updates be delivered to callers)?

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
- [x] Create CDN GCS bucket
- [x] Create Load Balancer (CDN)
- [x] Create upload script
- [ ] ~~Create Service Account with write permissions to CDN bucket~~ move to improvements

## WAR

### Outstanding questions
*NONE*

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
- [x] Create GKE
- [x] Deploy tomact helm to GKE
  * ~~Provide war and prevaylor path in config~~
  * ~~Enable ingress~~ used a public cluster
  * Persistent volume 
- [x] Create upload script

### Questions
1. ~~How do I test w/o a war file?~~
  - Found one from [A Sample Java Web Application – War file to Deploy and Test](https://www.middlewareinventory.com/blog/sample-web-application-war-file-download/)

## Documentation

### Requirements
- [/] The ability for us to build your environments, in scripts and/or documentation 
- [x] Links to any images needed to build your environments. - None
- [/] A plan for scaling the public release including hardware and software implications. This can include documents, diagrams and/or configuration scripts. If you see any issues scaling this application tell us about it and suggestions, you have for resolving the issues. 
* A paper based description on how monitoring would be implemented
  * Cloud Monitoring and Alerting
  * Load balancers
  * CPU and memory for web-server
  * Uptime check for both load balancers
* A narrative of the approach taken. 
  * What principles did you apply?
    * Get a solution out, while taking minimal assumptions, to enable the team to start validating their product. With a working solution, work with the developers to get more insights into their requirements and share recommendations with them.
  * Explanation of the decisions you made and why.
    * Many explanations are inline with the TODO.md and in the source
  * What end state do you envision (if you run out of time to implement)?

  * Why were certain tools selected?
    * Mentioned inline the `TODO.md` and in the source
  * Why you configured the tools as you did? 
    * GKE
  * What is your recommendation for future work if time allows? 
    * 

### Plan
- [/] Put setup and run in README.md
- [/] Put development in separate doc

### Shortcomings with solution
* Deployment of assets are not atomic
* No rolling deploy of WAR
* No versioning
* No rollback strategy
* No HTTPS

### Improvements
- [x] Store terraform state in GCS or use TFE 
- [x] tfvars in a tool like TFE, Vault, or CI secrets
- [x] move terraform folder to a separate repo
- [x] Terraform pre commit fmt
- [x] Move from prevayler to data storage option appropriate for companyNews use case
  * currently use a persistent disk. this will not work when there is more than one pod.
  * can still support prevayler localy for development by adding an interface to abstract the data storage
  * provide decision tree for choosing storage option
  * world wide and sub second response (spanner) or perhaps use cloud sql with memory store
  * mention leader election alternative?
- [x] Containerize war with tomcat, publish to GCR, and deploy helm specific for companyNews
  * proper health check
  * following deploys
  * versions 
- [x] Fix non-atomic, Deploy assets to different folders (paths) in a bucket and point to said folder from the newly released 
* Support HTTPS at the load balancers
* Update GKE to multi-zone
* Make GKE private
  * pros
    * reduce attack vector
    * avoid public ips
  * cons
    * requires a nat
    * can complicate accessing nodes
- [] Increase Node pool and deployment scaling