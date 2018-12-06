#
# a. Add the NPAS ("Network Policy and Access Services") Windows Server Role
#

Add-WindowsFeature -Name "NPAS" -IncludeManagementTools

#
# b. Download and install the Azure MFA NPS Extension
#

$NpsExtnForAzureMfaInstallerURL = "https://download.microsoft.com/download/B/F/F/BFFB4F12-9C09-4DBC-A4AF-08E51875EEA9/NpsExtnForAzureMfaInstaller.exe"

$NpsExtnForAzureMfaInstallerPath = Join-Path -Path $ENV:Temp -ChildPath "NpsExtnForAzureMfaInstaller.exe"

Invoke-WebRequest -Uri $NpsExtnForAzureMfaInstallerURL -OutFile $NpsExtnForAzureMfaInstallerPath -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

Start-Process -FilePath $NpsExtnForAzureMfaInstallerPath -ArgumentList "/install /quiet" -WindowStyle Hidden -Wait

#
# c. Run the Azure MFA NPS Extension Configuration Script
#

$AzureMfaNpsExtnConfigSetupPath = "C:\Program Files\Microsoft\AzureMfa\Config\AzureMfaNpsExtnConfigSetup.ps1"

& $AzureMfaNpsExtnConfigSetupPath

#
# d. Register the NPS Server in Active Directory
#

#
# e. Create RADIUS clients for the 2 RD Gateway Servers
#

$primaryGatewayVmName = "rdgw-01"
$secondaryGatewayVmName = "rdgw-02"
$existingDomainName = "nutchi.ca"

$SharedSecret = "fK77snB2Gk&z9*wI7JBYLjO^QkrYAfhx"

$primaryGatewayVmName, $secondaryGatewayVmName | New-NpsRadiusClient -Name $_  -Address $($_ + "." + $existingDomainName) -SharedSecret $SharedSecret