# Monitoring and Alerting

> A paper based description on how monitoring would be implemented

## General

Monitoring and logging can initially be done with Cloud Monitoring and Logging. A discussion should be had with the team around costs and features they desire to see if a non-managed alternative should be persued. 

All of the resources mentioned below should be able to be create via terraform (though, they may require the beta Google provider).

## Static Assets

The Static assets resources are managed by Google. 

I would recommend the one alert:
- Uptime check - alerts if /index.html endpoint is unavailable more than once in 1m

Time and asset should be discussed with the development team.

## Web Server

Logging is enabled for GKE and the WAR should log to stdout/stderr so they can be viewed in Cloud Logging.

Monitoring is enabled for GKE. I would recommend creating a dashboard with the following metrics:
- Memory usage (using the pod)
- CPU usage (using the pod)
- Response latency (using the LB)
- HTTP error rate (using the LB)

I would recommend the following base alerts, using uptime checks and alerts:
- Uptime check - alerts if /health endpoint is unavailable more than once in 1m
- Memory usage - alerts if memory usage is > 50% of limit in a 5m window
- CPU usage - alerts if memory usage is > 50% of limit in a 5m window
- Response latency - alerts if mean latency > 1s in a 5 minute period
- HTTP error rate - alerts if HTTP errors > 10% of all requests in a 10 minute period Alert Policy

These alerts should be adjusted as based on usage, tolerance of alerts, SLAs, and whether action is or can be taken.

I have not included storage in the monitoring and alerting, as I hope the storage solution would be changed in the short term. 

I have not included monitoring and alerting on nodes. To begin with we can use the pods as a proxy for node health.