# VM-Folder-List-Folder

function VM-Folder-List-Folder
{
$folderList = @("AMEA CSE", "APAC GSE", "CSD", "EU GSE", "MMEA CSE", "NABU GSE", "PH Core", "WFHS")

Start-Transcript -Path "ListOfSubFolders.txt"

Foreach ($folder in $folderList)
	{
	Write-Host "`nChecking---" $folder -ForegroundColor Yellow
	Get-Folder -Type VM -Name $folder | Get-Folder | select Name | sort Name | ft -auto
	}
	
Write-Host "`nCheck ListOfSubFolders.txt" -ForegroundColor Yellow

Stop-Transcript

Write-Host "Completed!" -ForegroundColor Yellow
}

VM-Folder-List-Folder