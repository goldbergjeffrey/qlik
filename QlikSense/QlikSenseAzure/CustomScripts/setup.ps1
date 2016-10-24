<# Custom Script for Windows #>

# If Path doesn't exist then create it
if (-Not (Test-Path "c:\tmp"))
{
	mkdir "c:\tmp"
}

$tmpfile = "c:\tmp\customscriptlog.txt"

$config = "c:\tmp\config.txt"


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
$pass = ConvertTo-SecureString -String $password -AsPlainText -Force
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $combinedName, $pass
#$SenseInstallParams = '-s -l c:\tmp\qliksenseinstall.log userwithdomain="' + $combinedName + '" userpassword="' + $password + '" dbpassword="' + $password + '" hostname="' + $vmname + '"'

#$passAsPlainText = $pass | ConvertFrom-SecureString

$vmName | Out-File $config -Append
$combinedName  | Out-File $config -Append
$password | Out-File $config -Append


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

function timestamp {
	$a = Get-Date
	$b = $a.ToString('yyyy-mm-ddThh:mm:ssZ')
	return $b
}

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
$Name = "HelloWorld"
$value = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Unrestricted -file C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.8\Downloads\0\hw.ps1"

New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name $Name -Value $value -PropertyType String -Force | Out-Null

# Download QlikSense Setup.exe here!!! (This sample uses Notepad++ as an example)
#Invoke-WebRequest 'https://notepad-plus-plus.org/repository/7.x/7.1/npp.7.1.Installer.x64.exe' -OutFile "c:\tmp\setup.exe"


(timestamp) + ' Adding firewall rule to Windows Firewall to match Azure port configuration' | Out-File $tmpfile -Append

New-NetFirewallRule -DisplayName "Qlik Sense" -Direction Inbound -action Allow -Protocol TCP -LocalPort 80,443,4248,4244 | Out-File $tmpfile -Append

(timestamp) + ' Firewall Rules added' | Out-File $tmpfile -Append


(timestamp) + ' Disabling Internet Explorer Security Mode' | Out-File $tmpfile -Append
Disable-InternetExplorerESC

Restart-Computer -Force
