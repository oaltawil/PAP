Param(
        # Connection Broker Computer Name
        [String]$connectionBroker,
        
        # Web Access Server Computer Name
        [String]$webAccessServer,

        # Gateway external FQDN
        [String]$externalFqdn
)

Import-Module RemoteDesktop

Add-RdServer -Server $webAccessServer -Role RDS-WEB-ACCESS -ConnectionBroker $connectionBroker

Add-RdServer -Server $webAccessServer -Role RDS-GATEWAY -ConnectionBroker $connectionBroker -GatewayExternalFqdn $externalFqdn
