$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path

$targets = @()
if ($ONLY_PACKAGE_IMAGES) {
    $includes = @()
    $includes += @($($ONLY_PACKAGE_IMAGES -split ','))
    $targets = Get-ChildItem -Path $SRC_PATH -Directory -Include $includes
} else {
    $excludes = @('scripts')
    if ($DONT_PACKAGE_IMAGES) {
        $excludes += @($($DONT_PACKAGE_IMAGES -split ','))
    }
    $targets = Get-ChildItem -Path $SRC_PATH -Directory -Exclude $excludes
}

$targets | Sort-Object -Descending | ForEach-Object {
    $dirName = $_.Name
    Invoke-Script -File "$SRC_PATH\$dirName\scripts\ci.ps1"
}
