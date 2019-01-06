# VM-Folder-Add-FromList

function VM-Folder-Add-FromList
{
$csv = "C:\data\fritz\script\ListOfMmea.csv" #Source CSV File
$ListFolder = @(Import-Csv $csv)
$folderLoc = Get-Folder -Name "MMEA" # VMFolder Destination

Foreach ($Item in $ListFolder)
	{
	Write-Host "Creating Folder" $Item.Name
	New-Folder -Location $folderLoc -Name $Item.Name
	}
Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Folder-Add-FromList