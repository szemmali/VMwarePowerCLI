# VM-PowerOn-FromList-Lucis

function VM-PowerOn-FromList-Lucis
{
$VMToPowerOn = @(Import-Csv "ListOfVmLucis.csv") #Declare CSV List
[int]$powerOnDelaySec = 10 #Time Delay between power on in seconds

Foreach ($VMName in $VMToPowerOn)
	{
	Write-Host "Starting VM:" $VMName.Name
	$VMView = Get-View -ViewType VirtualMachine -Filter @{"Name" = $VMName.Name}

	If ($VMView.Runtime.PowerState -eq "poweredOff")
		{
		Get-VM $VMName.Name | Start-VM -Confirm:$false > $null
		}
	Sleep $powerOnDelaySec
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-PowerOn-FromList-Lucis