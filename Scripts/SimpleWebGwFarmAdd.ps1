Param(
        # Connection Broker Computer Name
        [String]$ConnectionBroker,
        
        # Web Access Server Computer Name
        [String]$WebAccessServer,

        # Gateway external FQDN
        [String]$externalFqdn
)

Import-Module RemoteDesktop

Add-RdServer -Server $WebAccessServer -Role RDS-WEB-ACCESS -ConnectionBroker $ConnectionBroker

Add-RdServer -Server $WebAccessServer -Role RDS-GATEWAY -ConnectionBroker $ConnectionBroker -GatewayExternalFqdn $externalFqdn
