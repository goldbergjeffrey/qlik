<# Custom Script for Windows #>

# If Path doesn't exist then create it
if (-Not (Test-Path "c:\tmp"))
{
	mkdir "c:\tmp"
}

$tmpfile = "c:\tmp\customscriptlog.txt"


# Reading environment variables
"Environment test" | Out-File $tmpfile -Append
[Environment]::UserName | Out-File $tmpfile -Append
[Environment]::UserDomainName | Out-File $tmpfile -Append
[Environment]::MachineName | Out-File $tmpfile -Append

# Reading parameters passed to the script file
"Parameter test" | Out-File $tmpfile -Append
$vmName = $Args[0]
$userName = $Args[1]
$password = $Args[2]

#attempt to decrypt the password
$combinedName = $vmName + '\' + $userName
$Credentials = New-Object System.Management.Automation.PSCredential ` -ArgumentList $userName, $password
$pass = $Credentials.GetNetworkCredential().Password

$vmName | Out-File $tmpfile -Append
$userName | Out-File $tmpfile -Append
$password | Out-File $tmpfile -Append
$combinedName | Out-File $tmpfile -Append
$pass | Out-File $tmpfile -Append 

# Download QlikSense Setup.exe here!!! (This sample uses Notepad++ as an example)
Invoke-WebRequest 'https://notepad-plus-plus.org/repository/7.x/7.1/npp.7.1.Installer.x64.exe' -OutFile "c:\tmp\setup.exe"

Invoke-WebRequest 'https://da3hntz84uekx.cloudfront.net/QlikSense/3.1.1/1/_MSI/Qlik_Sense_setup.exe' -OutFile "c:\tmp\Qlik_Sense_setup.exe"

& "c:\tmp\Qlik_Sense_setup.exe" -silent -log "c:\tmp\qliksenseinstall.log" userwithdomain="$combinedName" userpassword="$password" dbpassword="$password" hostname="$vmname"

#& "c:\tmp\setup.exe" /S
"Adding firewall rule to Windows Firewall to match Azure port configuration" | Out-File $tmpfile -Append
New-NetFirewallRule -DisplayName "Qlik Sense" -Direction Inbound -action Allow -Protocol TCP -LocalPort 80,443,4248,4244 | Out-File $tmpfile -Append

function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    "IE Enhanced Security Configuration (ESC) has been disabled." | Out-File $tmpfile -Append
}
function Enable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 1
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 1
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been enabled." -ForegroundColor Green
}
function Disable-UserAccessControl {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000
    Write-Host "User Access Control (UAC) has been disabled." -ForegroundColor Green    
}

"Disabling Internet Explorer Security Mode" | Out-File $tmpfile -Append
Disable-InternetExplorerESC