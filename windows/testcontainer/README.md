# Test Container

An IIS Windows image forks from https://github.com/rancher/rancher/blob/master/tests/validation/tests/Dockerfiles/windows/testcontainer:

- Listen on `80`
- Get `hostname` or `CONTAINER_NAME` env when accessing `/name.html`, `/service1.html` and `/service2.html`
- Base on Windows core server

Another similar image is [win-iis](../win-iis).

## Build

``` powershell

./scripts/ci.ps1

```

## Images

https://cloud.docker.com/repository/docker/maiwj/testcontainer