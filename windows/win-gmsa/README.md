# gMSA

A Windows image for [gMSA testing](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa/):

- Listen on `80`
- Verify the gMSA account when accessing the root path
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

https://cloud.docker.com/repository/docker/maiwj/win-gmsa
