# VM-Snapshot-Delete-OlderXDays-Folders

function VM-Snapshot-Delete-OlderXDays-Folders
{
[int]$vmSnapshotAgeDays = -7
$folderName = @("AMEA CSE","APAC GSE","CSD","EU GSE","MMEA CSE","NABU GSE","PH Core","WF MSP","WFHS","Z-Orphan","Z-Uptime")

ForEach ($getFolder in $folderName)
	{
	$vmFolder = Get-Folder -Type VM -Name $getFolder
	$vm = @($vmFolder | Get-VM)
	
	ForEach ($singleVM in $vm)
		{
		Write-Host "Checking" $singleVM
		
		# Query offending VM Snapshots
		Get-VM -Name $singleVM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays($vmSnapshotAgeDays)} | Select-Object VM, Name, Created
		
		# Delete Action
		Write-Host "Removing Snapshot of" $singleVM
		Get-VM -Name $singleVM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays($vmSnapshotAgeDays)} | Remove-Snapshot -Confirm:$false
		}
	}

Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Snapshot-Delete-OlderXDays-Folders
