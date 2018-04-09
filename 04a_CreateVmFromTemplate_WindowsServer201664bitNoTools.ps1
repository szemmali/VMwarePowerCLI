# REPLACE THE VARIABLES WITH COMMENT "CHANGEME"
$i = 1
[int]$NumberToDeploy = 20 #CHANGEME-Max number to deploy
[string]$NamingConvention = "FirstName LastName Windows Server 2016 64bit NoTools" #CHANGEME-Name prefix of VM to create
[string]$folderLoc = "RDY-WindowsServer201664bit" #CHANGEME-VM Folder location to put the VMs

while ($i -le $NumberToDeploy)
	{
	$templateName = "Template Windows Server 2016 64bit notools" #CHANGEME-Source Template
	$esxName = "cnode-nec01.tekchallenge.local" #CHANGME-Destination Host
  $rpName = "Production" #CHANGEME-Destination Resource Pool
	$dsName = "STR-SAS01" #CHANGEME-Destination Datastore
  $dsCluster = "Support Services Storage" #CHANGEME-Destination Datastore Cluster
	
  $VMname = $NamingConvention + $i
	$template = Get-Template -Name $templateName
	
  # USE COMMENT TO SELECT WHETHER PRE-DEFINED DATASTORE ABOVE ($dsName) OR USE RANDOM DATASTORE FROM THE CLUSTER ($dsCluster)
  #$ds = Get-Datastore -Name $dsName
	$ds = Get-DatastoreCluster -Name $dsCluster | Get-Datastore | Get-Random
	
  $esx = Get-VMHost -Name $esxName
	$rp = Get-ResourcePool -Name $rpName
	
  # NETWORK / IGNORE THIS FOR NOW-IT DOES NOT WORK YET
  #$network = Get-VirtualPortGroup -name "dv_default"

  # CHECK IF THE VM EXISTS PRIOR CREATING FROM TEMPLATE
	if ((Get-VM $VMName -ErrorAction SilentlyContinue).Name -eq $VMName) 
		{
		Write-Host "$VMName already exists, skipping creation of this VM!" -ForegroundColor Yellow
		}
	
	else
		{
		# USE COMMENT WHETHER TO USE HOST OR RESOURCE POOL
    #New-VM -Location $folderLoc -Template $template -Name $VMname -VMHost $esx -Datastore $ds -DiskStorageFormat Thin | Set-VM -NumCpu 2 -MemoryGB 4 -Confirm:$false 
		New-VM -Location $folderLoc -Template $template -Name $VMname -ResourcePool $rp -Datastore $ds -DiskStorageFormat Thin | Set-VM -NumCpu 2 -MemoryGB 4 -Confirm:$false 
		Sleep 10 #TO AVOID SUCCEEDING DISK I/O
		}
	$i++
	}
  
Write-Host "Completed!!!"	
