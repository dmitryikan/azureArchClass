<#

2 Scripts on removing resources from Azure.
The first one will look for the VM name within the loop, if it finds it, it will continue past it

The 2nd is supposed to avoid the items after the -ne line, but it doesn't work and this exercise
is to fix it.

#>

$vms = get-azvm
$VMName = $vms.Name

$VMName

foreach ($actualVM in $VMName)  

{
 If($actualVM -eq 'freeTierVM1'){continue}
 else
 {remove-azvm -Name $actualVM -verbose -force}

};


##This powershell script will remove all resource groups and associated items except 
##the ones  after the -ne line
$azrg = Get-AzResourceGroup
if ($azrg.Count > 0)
{write-host "WARNING! COUNT GREATER THAN 0. TOTAL COUNT:$($azrg.count)" -ForegroundColor darkred}
foreach ($currentItem in $($azrg.ResourceGroupName) -ne ('cloudShellAcct','cloud-shell-storage-westus','Default-ActivityLogAlerts','NetworkWatcherRG'))
{
write-host "Current ResourceGroup Discovered: $($currentItem)"

#remove-azresourcegroup -name $currentItem -verbose -force
}




