param(
    $dnsLabelPrefix,
    $existingDomainName,
    $existingAdminUsername,
    $existingAdminPassword,
    $existingDnsServer,
    $loadBalancerIP
)

$cred = New-Object System.Management.Automation.PSCredential ("$existingDomainName\$existingAdminUsername", (ConvertTo-SecureString $existingAdminPassword -AsPlainText -Force))

Write-Output("Creating DNS Record")
Invoke-Command -ComputerName $existingDnsServer -Credential $cred -ScriptBlock {
        
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
