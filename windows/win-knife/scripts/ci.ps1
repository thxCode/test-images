$ErrorActionPreference = 'Stop'

$ROOT_PATH = (Resolve-Path "$PSScriptRoot\..\..").Path
Import-Module -Force -WarningAction Ignore -Name "$ROOT_PATH\scripts\utils.psm1"

Invoke-Script -File "$ROOT_PATH\scripts\version.ps1"
Invoke-Script -File "$PSScriptRoot\package.ps1"
Invoke-Script -File "$PSScriptRoot\release.ps1"
