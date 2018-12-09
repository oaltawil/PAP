# Create Highly-Available Remote Desktop Services Farm

This template deploys the following resources:

<ul><li>Azure Internal Load Balancer</li><li>2 RD Web Access / Gateway VMs</li><li>2 RD Connection Broker / Licensing Servers VMs</li><li>2 RD Session Host VMs</li><li>Azure SQL Server and Database (used by the Highly-Available Connection Broker Role)</li></ul>

The template requires a Virtual Network that contains Active Directory Domain Services (managed or unmanaged) and an Azure Key Vault that contains a Certificate (with Private Key) for the RD Gateway FQDN.

Click the button below to deploy

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Foaltawil%2FPAP%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Foaltawil%2FPAP%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>
