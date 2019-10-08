$ErrorActionPreference = 'Stop'

if (-not $GIT_TAG) {
    if ($env:DRONE_TAG) {
        $GIT_TAG = $env:DRONE_TAG
    } else {
        $GIT_TAG = $(git tag -l --contains HEAD | Select-Object -First 1)
    }
}
if ("$(git status --porcelain --untracked-files=no)") {
    $DIRTY = "-dirty"
}
$VERSION = "$(git rev-parse --short HEAD)${DIRTY}"
if ((-not $DIRTY) -and ($GIT_TAG)) {
    $VERSION = "${GIT_TAG}"
}
$env:VERSION = $VERSION

if (-not $ARCH) {
    if ($env:ARCH) {
        $ARCH = $env:ARCH
    } else {
        $ARCH = "amd64"
    }
}
$env:ARCH = $ARCH

if (-not $REPO) {
    if ($env:REPO) {
        $REPO = $env:REPO
    } else {
        $REPO = "maiwj"
    }
}
$env:REPO = $REPO

$HOST_RELEASE_ID = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -ErrorAction Ignore).ReleaseId
$env:HOST_RELEASE_ID = $HOST_RELEASE_ID

if (-not $RELEASE_ID) {
    if ($env:RELEASE_ID) {
        $RELEASE_ID = $env:RELEASE_ID
    } else {
        $RELEASE_ID = $HOST_RELEASE_ID
    }
}
$env:RELEASE_ID = $RELEASE_ID
