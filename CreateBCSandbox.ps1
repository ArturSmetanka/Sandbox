install-module BcContainerHelper -force

# set accept_eula to $true to accept the eula found here: https://go.microsoft.com/fwlink/?linkid=861843
$accept_eula = $false
$containername = ''
$licenseFile = ''
$auth = 'Windows'
$usessl = $false
$updateHosts = $true
$assignPremiumPlan = $true
$shortcuts = 'Desktop'

$artifactUrl = Get-BcArtifactUrl -version '21.3.51409.51575' -country 'DE' -select 'Closest'

if ($auth -eq 'Windows') {
    $credential = get-credential -UserName $env:USERNAME -Message 'Using Windows Authentication. Please enter your Windows credentials.'
}
elseif ($auth -eq 'UserPassword') {
    $credential = get-credential -Message 'Using Username/Password Authentication. Please enter credentials.'
}
else {
    throw '$auth needs to be either Windows or UserPassword'
}

if (!$accept_eula) {
    throw 'You have to accept the eula in order to create a Container.'
}
if (!($containername)) {
    throw 'You have to specify a container name in order to create a container.'
}
if (!($artifactUrl)) {
    throw 'No matching build was found for your version of Business Central'
}
New-BcContainer -accept_eula:$accept_eula `
                -containername $containername `
                -artifactUrl $artifactUrl `
                -auth $auth `
                -Credential $credential `
                -usessl:$usessl `
                -updateHosts:$updateHosts `
                -licenseFile $licenseFile `
                -assignPremiumPlan:$assignPremiumPlan `
                -shortcuts $shortcuts

if ($licenseFile) {
    Setup-BcContainerTestUsers -containerName $containername -password $credential.Password
}
