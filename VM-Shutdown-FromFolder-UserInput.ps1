# VM-Shutdown-FromFolder

function VM-Shutdown-FromFolder
{
$vmFolder = Read-Host 'input folder name' #Declare VM Folder
$getVM = @(Get-Folder -Name $vmFolder | Get-VM )

Foreach ($vmName in $getVM)
	{
	Write-Host "Shutting down VM:" $vmName
	$vmName | Where-Object {$_.PowerState -ne "PoweredOff" -and $_.Extensiondata.guest.ToolsRunningStatus -eq 'guestToolsRunning'} | Shutdown-VMGuest -Confirm:$false > $null
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Shutdown-FromFolder