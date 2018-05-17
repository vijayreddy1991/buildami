$ErrorActionPreference = "Stop"

$NODE_ARCHITECTURE = "$env:ARCHITECTURE"
$NODE_OPERATING_SYSTEM = "$env:OS"
$INIT_SCRIPT_NAME = "Docker_$env:DOCKER_VER.ps1"
$REQKICK_DOWNLOAD_URL = "$env:REQKICK_DOWNLOAD_URL"
$EXEC_IMAGE = "$env:REQPROC_IMAGE"

$NODE_SCRIPTS_LOCATION = "$env:USERPROFILE/node"
$NODE_SHIPCTL_LOCATION = "$NODE_SCRIPTS_LOCATION/shipctl"
$SHIPPABLE_FIREWALL_RULE_NAME = "shippable-docker"
$REQKICK_DIR = "$env:USERPROFILE/Shippable/reqKick"

$INSTALL_DOCKER_ONLY = $false

Write-Output "$NODE_ARCHITECTURE"
Write-Output "$NODE_OPERATING_SYSTEM"
Write-Output "$INIT_SCRIPT_NAME"
Write-Output "$REQKICK_DOWNLOAD_URL"
Write-Output "$EXEC_IMAGE"

Write-Output "|___Initializing node"
& "$NODE_SCRIPTS_LOCATION/initScripts/$NODE_ARCHITECTURE/$NODE_OPERATING_SYSTEM/$INIT_SCRIPT_NAME"
