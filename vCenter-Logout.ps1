#vCenter-Logout

function vCenter-Logout
{
$server = "VCENTER_FQDN"
Disconnect-VIServer -Server $server -Confirm:$false
}

vCenter-Logout
