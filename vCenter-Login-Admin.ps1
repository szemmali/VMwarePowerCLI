#vCenter-Login-Admin

function vCenter-Login-Admin
{
$server = "VCENTER_FQDN"
$user = "administrator@vsphere.local"
$pass = "PASSWORD"
Connect-VIServer -Server $server -User $user -Password $pass
}

vCenter-Login-Admin
