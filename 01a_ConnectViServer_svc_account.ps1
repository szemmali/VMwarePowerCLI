# REPLACE THE FOLLOWING VARIABLES
$server = "VCENTER_FQDN"
$user = "USERNAME_SVC_ACCOUNT"
$pass = "PASSWORD"

Connect-VIServer -Server $server -User $user -Password $pass
