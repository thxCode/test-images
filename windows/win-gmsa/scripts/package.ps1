$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path
if (-not (Test-Path -Path "$SRC_PATH\Dockerfile")) {
    Log-Warn "Could not found $SRC_PATH\Dockerfile"
    return
}

if (-not $DONET) {
    if ($env:DONET) {
        $DONET = $env:DONET
    } else {
        $DONET = "4.8"
    }
}

Push-Location $SRC_PATH

$imageName = Construct-ImageName
docker build `
    --build-arg DONET=$DONET `
    --tag $imageName `
    --file Dockerfile .
if (-not $?) {
    Pop-Location
    Log-Fatal "Failed to package $SRC_PATH\Dockerfile"
}

Log-Info "Built $imageName"

Pop-Location
