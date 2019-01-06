# VM-Disk-Provisioning-Check-Gold

function VM-Disk-Provisioning-Check-Gold
{
$datastoreClustersList = @("Support Services Gold Tier") #Declare Datastore Cluster to apply the script

#Provision if need to use Datastores instead of Datastore Cluster
#$datastoreGoldList = @("STR-AFA01-V01", "STR-AFA01-V02", "STR-AFA02-V01", "STR-AFA02-V02")
#$datastoreSilverList = @("STR-SAS01", "STR-SAS02", "STR-SASA03")

Foreach ($datastoreCluster in $datastoreClustersList)
	{
	
	Write-Host "`nChecking Datastore Cluster:" $datastoreCluster -ForegroundColor Yellow
	#Display information on console
	Write-Host "     Displaying on Console..."
	Get-DatastoreCluster -Name $datastoreCluster | Get-Datastore | Get-VM | Get-HardDisk | Where {$_.storageformat -eq "Thick" -and $_.Parent -notlike "cs-*" -and $_.Parent -notlike "*EdgeGW*" -and $_.Parent -notlike "*NSXCTRL*" -and $_.Parent -notlike "Fritz Reyes*"} | Select Parent, Name, CapacityGB, storageformat | FT -AutoSize
	
	#Export to report
	Write-Host "     Exporting to CSV the report..."
	Get-DatastoreCluster -Name $datastoreCluster | Get-Datastore | Get-VM | Get-HardDisk | Where {$_.storageformat -eq "Thick" -and $_.Parent -notlike "cs-*" -and $_.Parent -notlike "*EdgeGW*" -and $_.Parent -notlike "*NSXCTRL*" -and $_.Parent -notlike "Fritz Reyes*"} | Export-CSV -Append D:\PowerCLI_Logs\Report_CheckThickProvisionVmGold_$((Get-Date).ToString('yyyy-MM-dd_HH')).csv
	
	#Export for post processing
	Write-Host "     Exporting to CSV for post processing..."
	Get-DatastoreCluster -Name $datastoreCluster | Get-Datastore | Get-VM | Get-HardDisk | Where {$_.storageformat -eq "Thick" -and $_.Parent -notlike "cs-*" -and $_.Parent -notlike "*EdgeGW*" -and $_.Parent -notlike "*NSXCTRL*" -and $_.Parent -notlike "Fritz Reyes*"} | Select-Object Parent | Export-CSV -Append -NoTypeInformation -Path D:\PowerCLI_Logs\ListOfVmThickToThinGold.csv
	}

Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Disk-Provisioning-Check-Gold
