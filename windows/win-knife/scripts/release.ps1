$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path
if (-not (Test-Path -Path "$SRC_PATH\Dockerfile")) {
    return
}

Push-Location $SRC_PATH

$imageName = Construct-ImageName
docker push $imageName
if (-not $?) {
    Log-Fatal "Could not push $imageName : $pushLog"
}

Log-Info "Pushed $imageName"

Pop-Location
