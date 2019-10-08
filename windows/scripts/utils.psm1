$ErrorActionPreference = 'Stop'

function Log-Debug
{
    Write-Host -NoNewline -ForegroundColor White "DEBU: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($Args -join " "))
}

function Log-Info
{
    Write-Host -NoNewline -ForegroundColor Blue "INFO: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($Args -join " "))
}

function Log-Warn
{
    Write-Host -NoNewline -ForegroundColor DarkYellow "WARN: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($args -join " "))
}

function Log-Error
{
    Write-Host -NoNewline -ForegroundColor DarkRed "ERRO: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($args -join " "))
}


function Log-Fatal
{
    Write-Host -NoNewline -ForegroundColor DarkRed "FATA: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($args -join " "))

    exit 255
}

function Invoke-Script
{
    param (
        [parameter(Mandatory = $true)] [string]$File
    )

    if (-not (Test-Path -PathType Leaf -Path $File)) {
        return
    }
    Log-Debug "Invoke script $File"

    try {
        Invoke-Expression -Command $File
        if (-not $?) {
            Log-Fatal "Failed to invoke $File"
        }
    } catch {
        Log-Fatal "Could not invoke $File, $($_.Exception.Message)"
    }
}

function Judge
{
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)] [scriptBlock]$Block,
        [parameter(Mandatory = $false)] [int]$Timeout = 30,
        [parameter(Mandatory = $false)] [switch]$Reverse,
        [parameter(Mandatory = $false)] [switch]$Throw
    )

    $count = $Timeout
    while ($count -gt 0) {
        Start-Sleep -s 1

        if (&$Block) {
            if (-not $Reverse) {
                Start-Sleep -s 5
                break
            }
        } elseif ($Reverse) {
            Start-Sleep -s 5
            break
        }

        Start-Sleep -s 1
        $count -= 1
    }

    if ($count -le 0) {
        if ($Throw) {
            throw "Timeout"
        }

        Log-Fatal "Timeout"
    }

}

function Wait-Ready
{
    param(
        [parameter(Mandatory = $true)] $Path,
        [parameter(Mandatory = $false)] [int]$Timeout = 30,
        [parameter(Mandatory = $false)] [switch]$Throw
    )

    {
        Test-Path -Path $Path -ErrorAction Ignore
    } | Judge -Throw:$Throw -Timeout $Timeout
}

function Execute-Binary
{
    param (
        [parameter(Mandatory = $true)] [string]$FilePath,
        [parameter(Mandatory = $false)] [string[]]$ArgumentList,
        [parameter(Mandatory = $false)] [switch]$PassThru,
        [parameter(Mandatory = $false)] [switch]$Backgroud
    )

    if ($Backgroud) {
        if ($ArgumentList) {
            return Start-Process -WindowStyle Hidden -FilePath $FilePath -ArgumentList $ArgumentList -PassThru
        } else {
            return Start-Process -WindowStyle Hidden -FilePath $FilePath -PassThru
        }
    }

    if (-not $PassThru)
    {
        if ($ArgumentList) {
            Start-Process -NoNewWindow -Wait -FilePath $FilePath -ArgumentList $ArgumentList
        } else {
            Start-Process -NoNewWindow -Wait -FilePath $FilePath
        }
        return
    }

    $stdout = New-TemporaryFile
    $stderr = New-TemporaryFile
    $stdoutContent = ""
    $stderrContent = ""
    try {
        if ($ArgumentList) {
            Start-Process -NoNewWindow -Wait -FilePath $FilePath -ArgumentList $ArgumentList -RedirectStandardOutput $stdout.FullName -RedirectStandardError $stderr.FullName -ErrorAction Ignore
        } else {
            Start-Process -NoNewWindow -Wait -FilePath $FilePath -RedirectStandardOutput $stdout.FullName -RedirectStandardError $stderr.FullName -ErrorAction Ignore
        }

        $stdoutContent = Get-Content -Raw $stdout.FullName
        $stderrContent = Get-Content -Raw $stderr.FullName
    } catch {
        $stderrContent = $_.Exception.Message
    }

    $stdout.Delete()
    $stderr.Delete()

    if ([string]::IsNullOrEmpty($stderrContent)) {
        if (-not ([string]::IsNullOrEmpty($stdoutContent))) {
            if (($stdoutContent -match 'FATA') -or ($stdoutContent -match 'ERRO')) {
                return @{
                    Ok = $false
                    Output = $stdoutContent
                }
            }
        }

        return @{
            Ok = $true
            Output = $stdoutContent
        }
    }

    return @{
        Ok = $false
        Output = $stderrContent
    }
}

function Construct-Name
{
    param (
        [parameter(Mandatory = $false)] [string]$Repo = "",
        [parameter(Mandatory = $true)] [string]$Proj,
        [parameter(Mandatory = $false)] [string]$Version = "",
        [parameter(Mandatory = $false)] [string]$Release = "",
        [parameter(Mandatory = $false)] [string]$Suffix = ""
    )

    if ($Repo) {
        $Repo = "$Repo/"
    }
    if ($Version) {
        $Version = "${Version}-"
    }
    if ($Release) {
        $Release = "-$Release"
    }
    if ($Suffix) {
        $Suffix = "-$Suffix"
    }

    $ret = "${Repo}${Proj}:${Version}windows${Release}${Suffix}"
    Log-Debug "Image name: $ret"
    return $ret
}

function Construct-ImageName
{
    param (
        [parameter(Mandatory = $false)] [string]$Proj = $(Split-Path -Path . -Leaf),
        [parameter(Mandatory = $false)] [string]$Release = $env:RELEASE_ID
    )

    return Construct-Name -Repo $env:REPO -Proj $Proj -Version $env:VERSION -Release $Release
}

function Construct-MultipleVersionsName
{
    param (
        [parameter(Mandatory = $false)] [string]$Proj = $(Split-Path -Path . -Leaf)
    )

    return Construct-Name -Repo $env:REPO -Proj $Proj -Version $env:VERSION
}

function Construct-LatestVersionName
{
    param (
        [parameter(Mandatory = $false)] [string]$Proj = $(Split-Path -Path . -Leaf)
    )

    return Construct-Name -Repo $env:REPO -Proj $Proj
}

Export-ModuleMember -Function Log-Debug
Export-ModuleMember -Function Log-Info
Export-ModuleMember -Function Log-Warn
Export-ModuleMember -Function Log-Error
Export-ModuleMember -Function Log-Fatal
Export-ModuleMember -Function Judge
Export-ModuleMember -Function Wait-Ready
Export-ModuleMember -Function Invoke-Script
Export-ModuleMember -Function Execute-Binary
Export-ModuleMember -Function Construct-Name
Export-ModuleMember -Function Construct-ImageName
Export-ModuleMember -Function Construct-MultipleVersionsName
Export-ModuleMember -Function Construct-LatestVersionName
