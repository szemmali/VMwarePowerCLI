# VM-Disk-Provisioning-Remediate-Gold

function VM-Disk-Provisioning-Remediate-Gold
{
$vmList = @(Import-Csv D:\PowerCLI_Logs\ListOfVmThickToThinGold.csv)
[int]$svMotionDelayTimeSec = 10

Foreach ($vm in $vmList)
	{
	$ds = Get-Datastore | Where {$_.Name -eq "STR-AFA01-V01" -or $_.Name -eq "STR-AFA01-V02" -or $_.Name -eq "STR-AFA02-V01" -or $_.Name -eq "STR-AFA02-V02" -and $_.Name -ne ((Get-VM -Name $vm.Parent | Get-View).Config.DatastoreUrl.Name)} | Get-Random
	Write-Host "The random datastore is" $ds
	Write-Host "     Migrating ----" $vm.Parent "to" $ds -ForegroundColor Yellow
	Get-VM -Name $vm.Parent | Move-VM -Datastore $ds -DiskStorageFormat Thin
	sleep $svMotionDelayTimeSec
	}

Remove-Item D:\PowerCLI_Logs\ListOfVmThickToThinGold.csv

Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Disk-Provisioning-Remediate-Gold
