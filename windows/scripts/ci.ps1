$ErrorActionPreference = 'Stop'

Import-Module -Force -WarningAction Ignore -Name "$PSScriptRoot\utils.psm1"

Invoke-Script -File "$PSScriptRoot\package.ps1"
