$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path
if (-not (Test-Path -Path "$SRC_PATH\Dockerfile")) {
    Log-Warn "Could not found $SRC_PATH\Dockerfile"
    return
}

Push-Location $SRC_PATH

$imageName = Construct-ImageName
if ($env:RELEASE_ID -eq $env:HOST_RELEASE_ID) {
    docker build `
        --build-arg SERVERCORE=$env:RELEASE_ID `
        --tag $imageName `
        --file Dockerfile .
} else {
    docker build `
        --isolation hyperv `
        --build-arg SERVERCORE=$env:RELEASE_ID `
        --tag $imageName `
        --file Dockerfile .
}
if (-not $?) {
    Pop-Location
    Log-Fatal "Failed to package $SRC_PATH\Dockerfile"
}

Log-Info "Built $imageName"

Pop-Location