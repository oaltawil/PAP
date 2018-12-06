$existingDomainName = "nutchi.ca"
$npsVmName = "azuremfa"
$sharedSecret = "BlBwp22KzU73OMeX"
$primaryGatewayVmName = "rdgw-01"
$secondaryGatewayVmName = "rdgw-02"

#
# a. Add the NPAS ("Network Policy and Access Services") Windows Server Role
#

Add-WindowsFeature -Name "NPAS" -IncludeManagementTools

#
# b. Download and install the Azure MFA NPS Extension
#

$NpsExtnInstallerURL = "https://download.microsoft.com/download/B/F/F/BFFB4F12-9C09-4DBC-A4AF-08E51875EEA9/NpsExtnForAzureMfaInstaller.exe"

$NpsExtnInstallerPath = Join-Path -Path $ENV:Temp -ChildPath "NpsExtnForAzureMfaInstaller.exe"

Invoke-WebRequest -Uri $NpsExtnInstallerURL -OutFile $NpsExtnInstallerPath -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

Start-Process -FilePath $NpsExtnInstallerPath -ArgumentList "/install /quiet" -WindowStyle Hidden -Wait

#
# c. Automate the Azure MFA NPS Extension Configuration Script (i.e. WITHOUT ANY USER INTERACTION)
#

$NpsExtnConfigSetupPath = "C:\Program Files\Microsoft\AzureMfa\Config\AzureMfaNpsExtnConfigSetup.ps1"

& $NpsExtnConfigSetupPath

#
# d. Register the NPS Server in Active Directory
#

netsh nps add registeredserver $existingDomainName $npsVmName
# or the same command as above but without the domain name and server name: 
# netsh nps add registeredserver

#
# e. Create RADIUS clients for the 2 RD Gateway Servers
#

$primaryGatewayVmName, $secondaryGatewayVmName | New-NpsRadiusClient -Name $_  -Address $($_ + "." + $existingDomainName) -SharedSecret $sharedSecret

#
# f. Create a Network Policy to authorize valid connection requests
#

netsh nps add np name = "RDG_CAP" state = "enable" processingorder = "3" policysource = "0" conditionid = "0x1006" conditiondata = "0 00:00-24:00; 1 00:00-24:00; 2 00:00-24:00; 3 00:00-24:00; 4 00:00-24:00; 5 00:00-24:00; 6 00:00-24:00" profileid = "0x100f" profiledata = "TRUE" profileid = "0x7" profiledata = "0x1" profileid = "0x6" profiledata = "0x2"
<#
NP-Allow-Dial-in                        0x100f      "TRUE"
NP-Authentication-Type                  0x1009      "0x3" "0x9" "0x4" "0xa" "0x7"
Framed-Protocol                         0x7         "0x1"
Service-Type                            0x6         "0x2"

profileid = "0x100f" profiledata = "TRUE" profileid = "0x7" profiledata = "0x1" profileid = "0x6" profiledata = "0x2"
#>


