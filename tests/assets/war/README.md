# WAR

Test `SampleWebApp.war` locally with Docker. This Dockerfile would be used to seed creating a tagged image for each `.war` provided by a developer. The Dockerfile could then be deployed to GCR and the relevant `Deployment` could be updated with the with the latest tag.

## Test SampleWebApp with Docker

```
# Build
$ docker build -t samplewebapp .

# Run
$ docker run -it --rm -p 8080:8080 samplewebapp

# In a second terminal, view servlet
$ open http://localhost:8080/SampleWebApp/SnoopServlet

# Back in first terminal
# exit container
# CTRL+C

# Remove image
$ docker rmi samplewebapp
```