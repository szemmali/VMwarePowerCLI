#vCenter-Logout

function vCenter-Logout
{
$server = "cs-vcsa01.tekchallenge.local"
Disconnect-VIServer -Server $server -Confirm:$false
}

vCenter-Logout