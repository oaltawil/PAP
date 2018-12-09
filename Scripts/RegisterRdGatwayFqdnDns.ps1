param(
    $dnsLabelPrefix = "pap",
    $existingDomainName = "nutchi.ca",
    $existingDnsServer = "dc-01",
    $loadBalancerIP = "10.0.2.11"
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
    
        Add-DnsServerResourceRecordA -ZoneName $zone -Name $name -AllowUpdateAny -Ipv4Address $loadBalancerIP -TimeToLive 00:00:30 -ErrorAction Stop

    }

} -ArgumentList $existingDomainName, $dnsLabelPrefix, $loadBalancerIP
    
Write-Output("Completed writing DNS Record")
