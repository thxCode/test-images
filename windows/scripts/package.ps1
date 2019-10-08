$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path

$excludes = @('scripts')
if ($DONT_PACKAGE_IMAGES) {
    $excludes += @($($DONT_PACKAGE_IMAGES -split ','))
}

Get-ChildItem -Path $SRC_PATH -Directory -Exclude $excludes | Sort-Object -Descending | ForEach-Object {
    $dirName = $_.Name
    Invoke-Script -File "$SRC_PATH\$dirName\scripts\ci.ps1"
}
