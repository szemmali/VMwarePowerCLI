# VM-Snapshot-Delete-OlderXDays-Cluster

function VM-Snapshot-Delete-OlderXDays-Cluster
{
[int]$vmSnapshotAgeDays = -7
$clusterName = "Support Services" #Declare Cluster to check
$cluster = Get-Cluster -Name $clusterName

# Query offending VM Snapshots
$cluster | Get-VM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays($vmSnapshotAgeDays)} | Select-Object VM, Name, Created

# Delete Snapshot Action
$cluster | Get-VM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays($vmSnapshotAgeDays)} | Remove-Snapshot -Confirm:$false

Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Snapshot-Delete-OlderXDays-Cluster
