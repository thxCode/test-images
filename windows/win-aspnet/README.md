# ASP.net

A Windows image for ASP.net testing:

- Listen on `80`
- Count the number of accessing
- Output metric on /metrics
- Base on Windows core server


## Build

``` powershell

./scripts/ci.ps1

```

Change `donet` version:

``` powershell
$DONET="4.7.2"; ./scripts/ci.ps1

```

## Images

https://cloud.docker.com/repository/docker/maiwj/win-aspnet
