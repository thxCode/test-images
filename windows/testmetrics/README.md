# Test Metrics

A Windows image for Prometheus metrics testing which forks from https://github.com/rancher/rancher/blob/master/tests/validation/tests/Dockerfiles/windows/metrics:

- Listen on `8080`
- Count the number of accessing
- Output metric on `/metrics`
- Base on Windows nano server

Another similar image is [win-metric](../win-metric).

## Build

``` powershell

./scripts/ci.ps1

```

## Images

https://cloud.docker.com/repository/docker/maiwj/testmetrics