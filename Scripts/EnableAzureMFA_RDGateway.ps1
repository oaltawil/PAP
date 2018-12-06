$existingDomainName = "nutchi.ca"
$npsVmName = "azuremfa"
$npsFqdn = $npsVmName + "." + $existingDomainName
$sharedSecret = "BlBwp22KzU73OMeX"

Import-Module RemoteDesktopServices

#
# a. Enable the RD CAP Central Store and add the NPS Server
#

New-Item -Path RDS:\GatewayServer\NPSServers -Name $npsFqdn -SharedSecret $sharedSecret

Set-Item -Path RDS:\GatewayServer\CentralCAPEnabled -Value 1

Restart-Service -Name TSGateway

#
# b. Increase the RADIUS Timeout values 
#

netsh nps set remoteserver remoteservergroup = "TS GATEWAY SERVER GROUP" address = $npsFqdn timeout = 60 blackout = 60

Restart-Service -Name "IAS"