# VM-Name-Check-Remediate-SpecialCharacter

function VM-Name-Check-Remediate-SpecialCharacter
{
$cluster = "Support Services" #Declare Cluster Name to apply the script

#Query
Get-Cluster -Name "$cluster" | Get-VM | where {$_.Name -like "*/*" -or $_.Name -like "*|*" -or $_.Name -like "*:*"} | Select Name | Sort Name | Export-Csv D:\Scripts\powercli_scripts_scheduled\ListOfVmWithSpecialChar.csv

#Declare input file
$vmViolate = @(Import-Csv "D:\Scripts\powercli_scripts_scheduled\ListOfVmWithSpecialChar.csv") #Csv file should be the same with above exported Csv file

#Apply rename action
Foreach ($vm in $vmViolate)
	{
	Write-Host "Renaming ---" $vm.Name -ForegroundColor Yellow
	$newName = $vm.Name -replace '/','_'
	$newName = $newName -replace '\|','_'
	$newName = $newName -replace '\:',''
    $newName = $newName -replace [regex]::escape('[');
    $newName = $newName -replace [regex]::escape(']');
	Write-Host "     New Name ---" $newName -ForegroundColor Yellow
	Set-VM $vm.Name -Name $newName -Confirm:$false > $null
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

function VM-Name-Check-Remediate-SpecialCharacterPart2
{
$folderNames = @("AMEA CSE", "APAC GSE", "CSD", "EU GSE", "MMEA CSE", "NABU GSE", "PH Core", "WF MSP", "WFHS", "Z-Orphan", "Z-Uptime")

Foreach ($folder in $folderNames)
	{
	$vms = @(Get-Folder -Type VM -Name $folder | Get-VM | where {$_.name -match [regex]::escape('[') -or $_.name -match [regex]::escape(']')})
	
	Foreach ($vm in $vms)
		{
		Write-Host "Processing ---" $vm -ForegroundColor Yellow
		$vmName = $vm
		$newName = $vmName -replace [regex]::escape('[');
		$newName = $newName -replace [regex]::escape(']');
		Write-Host "     New VM Name ---" $newName
		Set-VM -Name $newName -VM $vm -Confirm:$false -ErrorAction SilentlyContinue
		}
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Name-Check-Remediate-SpecialCharacter
VM-Name-Check-Remediate-SpecialCharacterPart2
