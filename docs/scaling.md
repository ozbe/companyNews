# Scaling

> A plan for scaling the public release including hardware and software implications. This can include documents, diagrams and/or configuration scripts. If you see any issues scaling this application tell us about it and suggestions, you have for resolving the issues.

## Static Assets

There isn't much left to do with the static assets resources themselves with regards to scaling, it is all managed by Google. If performance degrades, I would evaluate other alternative CDNs or CDN solutions.

## Web Server (WAR)

### Prevaylor
The largest bottleneck for the web server implementation is prevaylor. By not supporting multiple writers, we are unable to scale horizontally.

The current implementation uses a persistent disk. This will not work when there is more than one pod, but will not help us meet our fully public requirements.

I would encourage the development team to consider another data storage alternative. They can visit [Cloud Storage Options | Google Cloud](https://cloud.google.com/products/storage/) to see options. 

My general recommendation for OLTP would be to use CloudSQL (possibly "fronted" by Memorystore) or Firestore, but they may need to consider something like Spanner if they need to deploy in other regions to support their subsecond response requirements.

We can still support prevayler for local development by adding an interface to abstract the data storage and toggle the data storage implementation with a configuration value that could be added to the helm deploy

* If they are only reading with prevaylor (which), then this is a non-issue as the data must be in the WAR and we can scale away.

If they are unable to change their data layer, we may have to consider something like a leader election or a more advanced load balancing solution to try to minimize downtime in the event of a pod failing

### GKE

The GKE solution is currently zonal, has a node pool with one node, said node is the lowest machine type available.

Regardless to whether the prevaylor problem is resolved, we can tune the [machine type for the primary node pool](../terraform/variables.tf) and the resources requested by the [helm release](../terraform/modules/company_news/web_server.tf)

If the prevaylor problem is resolved we should update GKE to be multi-zonal inorder to better support HA requirements. This will require terraform changes (specifically, support multiple zones) We should also increase node pool count and helm release replica count. Relevant increase terraform variables are `primary_node_count` and `company_news_web_server_replica_count`

### Helm Release

The [helm release](../terraform/modules/company_news/web_server.tf) `updateStrategy.type` should be changed to `RollingUpdate` to avoid downtime when rolling out updates

