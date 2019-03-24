#vCenter-Login-Admin

function vCenter-Login-Admin
{
$vcenter = "VCENTER_FQDN"
$username = "administrator@vsphere.local"
$password = Read-Host 'Enter The vCenter Password' -AsSecureString    
$vccredential = New-Object System.Management.Automation.PSCredential ($username, $password)
Connect-VIServer -Server $vCenter -Cred $vccredential -ErrorAction SilentlyContinue -WarningAction 0 | Out-Null
}

vCenter-Login-Admin
