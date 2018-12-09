param(
    
    $existingDomainName = "nutchi.ca",
    $dnsLabelPrefix = "pap",
    $loadBalancerIP = "10.0.2.50",
    $existingDnsServer = "dc-01"

)

Write-Output("Creating DNS Record")
Invoke-Command -ComputerName $existingDnsServer -ScriptBlock {
        
    param($existingdomainName, $dnsLabelPrefix, $loadBalancerIP)
        
    $zone = $existingDomainName
    $name = $dnsLabelPrefix

    if (Get-DnsServerResourceRecord -ZoneName $zone -Name $name -ErrorAction SilentlyContinue)
    {
        Remove-DnsServerResourceRecord -ZoneName $zone -Name $name -RRType "A" -Force
    }
    else {
    
        Add-DnsServerResourceRecordA -ZoneName $zone -Name $name -AllowUpdateAny -Ipv4Address $loadBalancerIP -PassThru -TimeToLive 00:00:30 -ErrorAction Stop

    }
 
    Write-Output("Successfully created host (address) record for the Dns Label Prefix of the RD Gateway FQDN")

} -ArgumentList $existingDomainName, $dnsLabelPrefix, $loadBalancerIP
    
Write-Output("Completed writing DNS Record")
