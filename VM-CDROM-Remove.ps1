# VM-CDROM-Remove

function VM-CDROM-Remove
{
$cluster = "Support Services" #Cluster Name to apply the script
$vms = Get-Cluster -Name $cluster | Get-VM
$cdConnected = @(Get-CDDrive $vms | where { ($_.ConnectionState.Connected -eq "true") })

Foreach ($cd in $cdConnected)
	{
	Write-Host "Removing CD-ROM of:" $cd.Parent
		If ($cd -ne $null)
			{
			Set-CDDrive -nomedia -connected 0 -StartConnected 0 $CD -Confirm:$false > $null
			}
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-CDROM-Remove
