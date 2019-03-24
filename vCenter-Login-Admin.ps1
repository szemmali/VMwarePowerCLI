#vCenter-Login-Admin

function vCenter-Login-Admin
{
$server = "VCENTER_FQDN"
$user = "administrator@vsphere.local"
$password = Read-Host 'Enter The vCenter Password' -AsSecureString
$vccredential = New-Object System.Management.Automation.PSCredential ($username, $password)
Connect-VIServer -Server $server -Cred $vccredential -ErrorAction SilentlyContinue -WarningAction 0 | Out-Null
}

vCenter-Login-Admin
