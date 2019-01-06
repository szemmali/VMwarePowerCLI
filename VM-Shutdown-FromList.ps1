# VM-Shutdown-FromList-Lagrange

function VM-Shutdown-FromList-Lagrange
{
$getVM = @(Import-Csv -Path "D:\Scripts\powercli_scripts_tekchallenge\ListOfLagrangeVM_Shutdown.csv")

Foreach ($vmName in $getVM)
	{
	Write-Host "Shutting down VM:" $vmName.Name
	Get-VM -Name $vmName.Name | Where-Object {$_.PowerState -ne "PoweredOff" -and $_.Extensiondata.guest.ToolsRunningStatus -eq 'guestToolsRunning'} | Shutdown-VMGuest -Confirm:$false > $null
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Shutdown-FromList-Lagrange