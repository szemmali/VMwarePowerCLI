# REPLACE THE FOLLOWING VARIABLES
$server = "VCENTER_FQDN"
$user = "USERNAME_SVC_ACCOUNT"
$pass = "PASSWORD"

Connect-NsxServer -vCenterServer $server -Username $user -Password $pass
