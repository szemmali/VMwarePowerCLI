# VM-Migrate-ComputeAndStorage-FromHost
# Use case is Swing Host

function VM-Migrate-ComputeAndStorage-FromHost
{
$vmHost = "10.10.158.153" #Replace this and input source ESXi Host
$vms = @(Get-VMHost -Name $vmHost | Get-VM)

$folderName = "Fritz Reyes Lucis" #Replace this with the destination VM folder
$esxiName = "cnode-dellemc03.tekchallenge.local" #Replace this with the destination ESXi host
$rpName = "Production" #Replace this with the destination Resource Pool

# To get the Port Group, use below command and change the wildcard
#Get-VirtualPortGroup | where {$_.name -like "*Cristina*"} | ft -auto
$newNetworkName = "vxw-dvs-84-virtualwire-918-sid-5446-Fritz Reyes Lucis Server Network" #Replace this with the destination Virtual Switch / Logical Switch

$folder = (Get-Folder -Type VM -Name $folderName)
$esxi = Get-VMHost -Name $esxiName
$rp = Get-ResourcePool -Name $rpName
$newNetwork = Get-VDPortgroup -Name $newNetworkName
	
Foreach ($vm in $vms)
	{
	# Choose one below to select datastore
	$datastore = Get-Datastore | Where {$_.Name -eq "STR-AFA01-V01" -or $_.Name -eq "STR-AFA01-V02" -or $_.Name -eq "STR-AFA02-V01" -or $_.Name -eq "STR-AFA02-V02"} | Get-Random
	#$datastore = Get-Datastore | Where {$_.Name -eq "STR-SAS01" -or $_.Name -eq "STR-SAS02" -or $_.Name -eq "STR-SAS03" -or $_.Name -eq "STR-SAS04"} | Get-Random
	
	Write-Host "`nMigrating " $vm "to Datastore "$datastore "and Server/ResourcePool " $rp -ForegroundColor Yellow
	$vm | Move-VM -Datastore $datastore -DiskStorageFormat Thin -InventoryLocation $folder -Destination $rp
	$vm | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newNetwork -Confirm:$false
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Migrate-ComputeAndStorage-FromHost