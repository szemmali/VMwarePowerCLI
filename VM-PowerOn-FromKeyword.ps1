# VM-PowerOn-FromKeyword

function VM-PowerOn-FromKeyword
{
$keyword = "*Windows Server 2016*" #Replace This keyword
$vmFolder = "Z-RDY-VM" #VM Folder
[int]$powerOnDelaySec = 10 #Time Delay between power on in seconds
$vmlist = @(Get-Folder -Name $vmFolder | Get-VM -Name $keyword) #Get VM inside the VM folder with matching keyword

Foreach	($vm in $vmlist)
	{
	if ($vm.PowerState -ne "PoweredOff" )
		{
		Write-Host "VM is powered on, skip this VM..." $vm
		}
	
	else
		{
		Write-Host "Powering on..." $vm
		$vm | Start-VM
		Sleep $powerOnDelaySec
		}
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-PowerOn-FromKeyword