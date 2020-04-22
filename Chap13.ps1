




<#
This top part is only for getting resource groups and such.  
To create the virtual networks, subnets, and associate them together look at the $virtualNetwork part and below
#>
$RGName = 'FreeTier'
$getRG = Get-AzResourceGroup | Where-object {$_.ResourceGroupName -eq $($RGName)} | select-object {$_.ResourceGroupName}

if ($getRG -eq $null)
{write-host 'lol' -ForegroundColor green}
else
{write-host 'test' -ForegroundColor red};



$MyRes = Get-AzResourceGroup -Name "FreeTier"
if ($null = $MyRes) {
 write-host "does not exist"
}



$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName PacktLoadBalancer `
  -Location EastUS `
  -Name PacktLBVnet `
  -AddressPrefix 172.16.0.0/16


  $subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name PacktLBBackendSubnet `
  -AddressPrefix 172.16.0.0/24 `
  -VirtualNetwork $virtualNetwork


  $virtualNetwork | Set-AzVirtualNetwork



  ##Add if exists check first
  $splat = @{
    Location = "EastUS"
    Name = "PacktLBAvailabilitySet"
    ResourceGroupName = "PacktLoadBalancer"
    Sku = "aligned"
    PlatformFaultDomainCount = 2
    PlatformUpdateDomainCount = 5
}

New-AzAvailabilitySet @splat



$Cred = Get-Credential
New-AzVm `
        -ResourceGroupName "PacktLoadBalancer" `
        -Name "PacktLBVM1" `
        -Location "EastUS" `
        -VirtualNetworkName "PacktLBVnet" `
        -SubnetName "PacktLBBackendSubnet" `
        -SecurityGroupName "NSG" `
        -AvailabilitySetName "PacktLBAvailabilitySet" `
        -Credential $cred 
    



New-AzVm `
        -ResourceGroupName "PacktLoadBalancer" `
        -Name "PacktLBVM2" `
        -Location "EastUS" `
        -VirtualNetworkName "PacktLBVnet" `
        -SubnetName "PacktLBBackendSubnet" `
        -SecurityGroupName "NSG" `
        -AvailabilitySetName "PacktLBAvailabilitySet" `
        -Credential $cred 


