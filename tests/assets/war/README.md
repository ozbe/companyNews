# WAR

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