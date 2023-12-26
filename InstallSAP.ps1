<#PSScriptInfo
.VERSION 1.1
.AUTHOR Yesua Menchón
.COPYRIGHT
.RELEASENOTES
Version 1.0: Initial version.
.PRIVATEDATA
#>

# Variables
$SAPInstallerPath = ".\SAP_7.5_Good_20231024_1648.exe" 
$InstallCommand = "/Silent /norestart"

# Check if the installer exists
if (Test-Path $SAPInstallerPath) {
    # Install SAP
    Start-Process -FilePath $SAPInstallerPath -ArgumentList $InstallCommand -Wait
}

# Wait for SAP Logon to open completely
Start-Sleep -Seconds 300

# Command to open SAP Logon
$commandToOpenSAPLogon = "C:\Program Files (x86)\SAP\FrontEnd\SAPgui\saplogon.exe" 

# Check if SAP Logon is running, otherwise open it
if (-not (Get-Process "SAPLogon" -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath $commandToOpenSAPLogon
}

# Wait to ensure SAP Logon has opened completely
Start-Sleep -Seconds 15

# Find the SAP Logon process
$processName = "saplogon"
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue

if ($process -ne $null) {
    # Close the SAP Logon process
    Stop-Process -Name $processName
}

# Path of the file on the network
$sourceFile = "\\10.133.4.3\datosred\aplicaciones\desktop\SAP\SAPUILandscape.xml"

# Destination path for the file in the current user's profile
$destinationFolder = "$env:APPDATA\SAP\Common\SAPUILandscape.xml"

# Copy the file from the remote location to the current user's profile folder
Copy-Item -Path $sourceFile -Destination $destinationFolder
