# Test Nginx

A Windows image for Nginx which forks from https://github.com/rancher/rancher/blob/master/tests/validation/tests/Dockerfiles/windows/nginx:

- Listen on `80`
- Base on Windows core server

Another similar image is [win-openresty](../win-openresty).

## Build

``` powershell

./scripts/ci.ps1

```

## Images

https://cloud.docker.com/repository/docker/maiwj/testnginx