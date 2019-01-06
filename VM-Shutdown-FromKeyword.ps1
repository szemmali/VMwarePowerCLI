# VM-Shutdown-FromKeyword

function VM-Shutdown-FromKeyword
{
$keyword = "*Windows 10*" #Replace This keyword
$vmFolder = "Z-RDY-VM" #VM Folder
[int]$powerOnDelaySec = 10 #Time Delay between power on in seconds
$vmlist = @(Get-Folder -Name $vmFolder | Get-VM -Name $keyword) #Get VM inside the VM folder with matching keyword

Foreach	($vm in $vmlist)
	{
	if ($vm.PowerState -eq "PoweredOff" )
		{
		Write-Host "VM is powered off, skip this VM..." $vm
		}
	
	if (($vm | get-view).guest.ToolsStatus -eq "guestToolsRunning")
		{
		Write-Host "Shutting down..." $vm
		$vm | Shutdown-VMGuest -Confirm:$false
		}
		
	else
		{
		Write-Host "Power Off..." $vm
		$vm | Stop-VM -Confirm:$false
		}
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Shutdown-FromKeyword