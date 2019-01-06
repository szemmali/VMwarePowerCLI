#NSX-Login

function NSX-Login
{
$vcsa = "VCENTER_FQDN"
$user = "administrator@vsphere.local"
$pass = "PASSWORD"
Connect-NsxServer -vCenterServer $vcsa -Username $user -Password $pass
}

NSX-Login
