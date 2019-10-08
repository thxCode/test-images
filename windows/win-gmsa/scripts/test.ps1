$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path
if (-not (Test-Path -Path "$SRC_PATH\Dockerfile")) {
    Log-Warn "Could not found $SRC_PATH\Dockerfile"
    return
}

Push-Location $SRC_PATH

$imageName = Construct-ImageName
$dockerRunID = ""
try {
    $dockerRunID = $(docker run -d -p 80:80 $imageName 2>&1)
    if (-not $?) {
        Log-Error "Could not start $imageName : $dockerRunID"
    } else {
        # timeout if getting failed
        {
            $resp = $(curl.exe -sL -w "%{http_code}" -o /dev/null http://127.0.0.1)
            Log-Debug "/ http_code: $resp"
            return ($resp -eq "401")
        } | Judge -Throw -Timeout 15

        Log-Info "Tested $imageName"
    }
} 
catch {
    Log-Error "Could not run $imageName : $($_.Exception.Message)"
} 
finally {
    if ($dockerRunID) {
        docker rm -f $dockerRunID 2>&1| Out-Null
    }
}

Pop-Location
