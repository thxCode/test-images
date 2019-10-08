# gMSA

- Verify your gMSA account when accessing the root

## Building

``` powershell

./scripts/ci.ps1

```

Change `donet` version:

``` powershell
$DONET="4.7.2"; ./scripts/ci.ps1

```

## Images

Introducing two image tags:

- `maiwj/win-gmsa:[version]-windows-[release_id]`
- `maiwj/win-gmsa:[version]-windows`: the manifest image
- `maiwj/win-gmsa:windows`: the latest image
