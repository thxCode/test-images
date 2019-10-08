$ErrorActionPreference = 'Stop'

Import-Module -Force -WarningAction Ignore -Name "$PSScriptRoot\utils.psm1"

Invoke-Script -File "$PSScriptRoot\package.ps1"

Invoke-Script -File "$PSScriptRoot\version.ps1"

if (-not $RELEASE_IDS) {
    if ($env:RELEASE_IDS) {
        $RELEASE_IDS = $env:RELEASE_IDS
    }
}
if (-not $RELEASE_IDS) {
    Log-Error "Could not found release id list, please indicate RELEASE_IDS"
    return 
}

$excludes = @('scripts')
if ($DONT_PACKAGE_IMAGES) {
    $excludes += @($($DONT_PACKAGE_IMAGES -split ','))
}

$env:DOCKER_CLI_EXPERIMENTAL="enabled"

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path
Get-ChildItem -Path $SRC_PATH -Directory -Exclude $excludes | Sort-Object -Descending | ForEach-Object {
    $dirName = $_.Name

    $versionNames = @()
    $RELEASE_IDS -split ',' | ForEach-Object {
        $versionNames += @($(Construct-ImageName -Proj $dirName -Release $_))
    }
    $versionNames = $versionNames -join " "

    $multipleVersionsName = Construct-MultipleVersionsName -Proj $dirName
    start-process -NoNewWindow -Wait -FilePath docker.exe -ArgumentList "manifest create $multipleVersionsName $versionNames --amend"
    if ($?) {
        start-process -NoNewWindow -Wait -FilePath docker.exe -ArgumentList "manifest push $multipleVersionsName --purge"
        if ($?) {
            Log-Info "Pushed $multipleVersionsName"
        } else {
            Log-Error "Could not push multiple version manifest $multipleVersionsName"
        }
    } else {
        Log-Error "Could not create multiple version manifest $multipleVersionsName"
    }

    $latestVersionName = Construct-LatestVersionName -Proj $dirName
    start-process -NoNewWindow -Wait -FilePath docker.exe -ArgumentList "manifest create $latestVersionName $versionNames --amend"
    if ($?) {
        start-process -NoNewWindow -Wait -FilePath docker.exe -ArgumentList "manifest push $latestVersionName --purge"
        if ($?) {
            Log-Info "Pushed $latestVersionName"
        } else {
            Log-Error "Could not push last version manifest $latestVersionName"
        }
    } else {
        Log-Error "Could not create last version manifest $latestVersionName"
    }

}
