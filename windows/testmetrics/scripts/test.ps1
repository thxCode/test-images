$ErrorActionPreference = 'Stop'

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..").Path
if (-not (Test-Path -Path "$SRC_PATH\Dockerfile")) {
    return
}

Push-Location $SRC_PATH

$imageName = Construct-ImageName
$dockerRunID = ""
try {    
    $dockerRunID = $(docker run -d -p 80:8080 $imageName 2>&1)
    if (-not $?) {
        Log-Error "Could not start $imageName : $dockerRunID"
    } else {
        # timeout if getting failed
        {
            $resp = $(curl.exe -sL http://127.0.0.1)
            Log-Debug "/ : $resp"
            if ($resp -match "^Hello\s+There!\d+") {
                $count = $($resp -split " ")[1]
                $metric = $(curl.exe -sL http://127.0.0.1/metrics)
                Log-Debug "/metrics : $metric"
                return ("web_app_online_user_count $count" -eq $metric)
            }

            return $false
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
