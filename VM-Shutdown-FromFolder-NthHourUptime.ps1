# VM-Shutdown-FromFolder-NthHourUptime

function VM-Shutdown-FromFolder-NthHourUptime
{
# INPUT Folder Name where VMs to shutdown reside, and specify hour uptime
$folderName = @("AMEA CSE","APAC GSE","CSD","EU GSE","MMEA CSE","NABU GSE","PH Core","WFHS")
$hoursUptime = 9

Foreach ($getFolder in $folderName)
	{
	Write-Host "Checking Folder:" $getFolder "----"
	
	# Declare VM Folder
	$vmFolder = Get-Folder -Type VM -Name $getFolder
	
	# Declare VMs inside a Folder + IF condition statement
	$vm = @($vmFolder | Get-VM)
	
	Foreach ($singleVM in $vm)
		{
		Write-Host "`nChecking VM:" $singleVM "----" -ForegroundColor Yellow
	
		#If ($singleVM.ExtensionData.Guest.ToolsRunningStatus -eq 'guestToolsRunning' -and $singleVM.Name -like "cs-*" -and $singleVM.Name -like "*EU GATEWAY DNS*")
		#	{
		#		Write-Host "This VM is in the exception list and does not have VMware Tools, do nothing for this VM..."
		#	}
		
		#If ($singleVM.ExtensionData.Guest.ToolsRunningStatus -eq 'guestToolsNotRunning' -and $singleVM.Name -like "*IMSVA*" -and $singleVM.Name -like "*SPS*" -and $singleVM.Name -like "*EU DataCenter*")
		#	{
		#		Write-Host "This VM is in the exception list and does not have VMware Tools, do nothing for this VM..."
		#	}
				
		If ($singleVM.PowerState -eq "PoweredOff")
			{ Write-Host "     If this VM is Powered Off, do nothing for this VM..." }

		# Check if uptime more than specified variable and shutdown the VM
		If ($singleVM.ExtensionData.Guest.ToolsRunningStatus -eq 'guestToolsRunning' -and $singleVM.PowerState -ne "PoweredOff" -and $singleVM.Name -notlike "*cs-*" -and $singleVM.Name -notlike "Fritz Reyes ESXi 1" -and $singleVM.Name -notlike "NABU GSE DeepSecurity FreeNAS")
			{
			Write-Host "     If shis VM has VMware Tools Running, shutting down..." -ForegroundColor Yellow
			Get-Stat -Entity $singleVM -Stat sys.uptime.latest -Realtime -MaxSamples 1 -ErrorAction SilentlyContinue | Select @{N='VM';E={$_.Entity.Name}},@{N='Uptime';E={[math]::Round((New-Timespan -Seconds $_.Value).TotalHours)}} | Where {$_.Uptime -gt $hoursUptime} | ForEach-Object {Get-VM -Name $_.VM | Shutdown-VMGuest -Confirm:$false} | Export-Csv -Append D:\PowerCLI_Logs\Report_VM-Shutdown-FromFolder-NthHourUptime_$((Get-Date).ToString('MM-dd-yyyy_HH')).csv
			}
			
		# Check if uptime more than specified variable and power off the VM
		If ($singleVM.ExtensionData.Config.GuestFullName -Like "*Windows*" -and $singleVM.extensiondata.guest.ToolsRunningStatus -ne 'guestToolsRunning' -and $singleVM.Name -notlike "*cs-*" -and $singleVM.Name -notlike "Fritz Reyes ESXi 1" -and $singleVM.Name -notlike "NABU GSE DeepSecurity FreeNAS")
			{
			Write-Host "     If this VM is Windows and VMware Tools is NOT running, power off the VM..." -ForegroundColor Yellow
			Get-Stat -Entity $singleVM -Stat sys.uptime.latest -Realtime -MaxSamples 1 -ErrorAction SilentlyContinue | Select @{N='VM';E={$_.Entity.Name}},@{N='Uptime';E={[math]::Round((New-Timespan -Seconds $_.Value).TotalHours)}} | Where {$_.Uptime -gt $hoursUptime} | ForEach-Object {Get-VM -Name $_.VM | Stop-VM -Confirm:$false} | Export-Csv -Append D:\PowerCLI_Logs\Report_VM-Shutdown-FromFolder-NthHourUptime_$((Get-Date).ToString('MM-dd-yyyy_HH')).csv
			}
			
		# Check if uptime more than specified variable and power off the VM
		If ($singleVM.ExtensionData.Config.GuestFullName -notlike "*Windows*" -and $singleVM.extensiondata.guest.ToolsRunningStatus -ne 'guestToolsRunning' -and $singleVM.Name -notlike "*cs-*" -and $singleVM.Name -notlike "Fritz Reyes ESXi 1" -and $singleVM.Name -notlike "NABU GSE DeepSecurity FreeNAS")
			{
			Write-Host "     If this VM is not Windows and VMware Tools is NOT running, power off the VM..." -ForegroundColor Yellow
			Get-Stat -Entity $singleVM -Stat sys.uptime.latest -Realtime -MaxSamples 1 -ErrorAction SilentlyContinue | Select @{N='VM';E={$_.Entity.Name}},@{N='Uptime';E={[math]::Round((New-Timespan -Seconds $_.Value).TotalHours)}} | Where {$_.Uptime -gt $hoursUptime} | ForEach-Object {Get-VM -Name $_.VM | Stop-VM -Confirm:$false} | Export-Csv -Append D:\PowerCLI_Logs\Report_VM-Shutdown-FromFolder-NthHourUptime_$((Get-Date).ToString('MM-dd-yyyy_HH')).csv
			}
				
		Else 
			{ Write-Host "     If no above condition matched, do nothing for this VM..." }
		}		
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Shutdown-FromFolder-NthHourUptime
