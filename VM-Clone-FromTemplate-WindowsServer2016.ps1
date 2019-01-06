# VM-Clone-FromTemplate-WindowsServer2016

function VM-Clone-FromTemplate-WindowsServer2016
{
$i = 1
[int]$NumberToDeploy = 1 #No. of clone to deploy
[string]$NamingConvention = "FName LName Windows Server 2016 64bit" #VM Clone Naming Convention
[string]$folderLoc = "RDY-WindowsServer201664bit" #VM Folder to place the clones
$parentFolderReadyVM = "Z-RDY-VM"
[int]$numCPU = 2
[int]$coresPerSocket = 2
[int]$numMemoryGB = 4
[int]$cloneDelayTimeSec = 10
$network = Get-VirtualPortGroup -name "dv_default" #Virtual Switch
$rp = Get-ResourcePool -Name "Production" #Resource Pool
$templateName = "Template Windows Server 2016 64bit" #VM Template source
$template = Get-Template -Name $templateName
	
while ($i -le $NumberToDeploy)
	{
	$VMname = $NamingConvention + $i #VM Clone Name increment
	
	#Enable this is you will use ESXi Host instead of Resource Pool
	#$esxName = "cnode-nec01.tekchallenge.local" 
	#$esx = Get-VMHost -Name $esxName
	
	#Choose only one $ds option below for destination Datastore
	#$ds = Get-Datastore | Where {$_.Name -eq "STR-SAS01" -or $_.Name -eq "STR-SAS02" -or $_.Name -eq "STR-SAS03" -or $_.Name -eq "STR-SAS04"} | Get-Random
	$ds = Get-Datastore | Where {$_.Name -eq "STR-AFA01-V01" -or $_.Name -eq "STR-AFA01-V02" -or $_.Name -eq "STR-AFA02-V01" -or $_.Name -eq "STR-AFA02-V02"} | Get-Random
	
	#Check if a Clone VM with same name exists
	if ((Get-Folder -Name $parentFolderReadyVM | Get-VM $VMName -ErrorAction SilentlyContinue).Name -eq $VMName) 
		{
		Write-Host "$VMName already exists, skipping creation of this VM!" -ForegroundColor Yellow
		}
	
	else
		{
		#Choose wheter use ESXi Host or Resource Pool, Resource Pool is recommended
		#New-VM -Location $folderLoc -Template $template -Name $VMname -VMHost $esx -Datastore $ds -DiskStorageFormat Thin | Set-VM -NumCpu 2 -CoresPerSocket 2 -MemoryGB 4 -Confirm:$false 
		New-VM -Location $folderLoc -Template $template -Name $VMname -ResourcePool $rp -Datastore $ds -DiskStorageFormat Thin | Set-VM -NumCpu $numCPU -CoresPerSocket $coresPerSocket -MemoryGB $numMemoryGB -Confirm:$false
		Get-VM -Name $VMName | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $network -Confirm:$false
		Sleep $cloneDelayTimeSec
		}
	$i++
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Clone-FromTemplate-WindowsServer2016