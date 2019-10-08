# Test Images Group

## Building

``` powershell

./windows/scripts/ci.ps1

```

Skip packaging `win-iis` and `win-gmsa`:

``` powershell
$DONT_PACKAGE_IMAGES="win-iis,win-gmsa"; ./windows/scripts/ci.ps1

```

Tag images to `your` repo:

``` powershell
$REPO="your"; ./windows/scripts/ci.ps1

```

## Manifest

``` powershell

$RELEASE_IDS="1809,1903"; ./windows/scripts/manifest.ps1

```
