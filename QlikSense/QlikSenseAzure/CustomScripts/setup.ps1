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
$pass = ConvertTo-SecureString -String $password -AsPlainText -Force
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $combinedName, $pass
$SenseInstallParams = '-s -l c:\tmp\qliksenseinstall.log userwithdomain=' + $combinedName + ' userpassword=' + $password + ' dbpassword=' + $password + ' hostname=' + $vmname


$vmName | Out-File $tmpfile -Append
$userName | Out-File $tmpfile -Append
$password | Out-File $tmpfile -Append
$combinedName | Out-File $tmpfile -Append
$pass | Out-File $tmpfile -Append 
$SenseInstallParams | Out-File $tmpfile -Append


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

# Download QlikSense Setup.exe here!!! (This sample uses Notepad++ as an example)
#Invoke-WebRequest 'https://notepad-plus-plus.org/repository/7.x/7.1/npp.7.1.Installer.x64.exe' -OutFile "c:\tmp\setup.exe"

timestamp + ' Downloading Visual C++ 2010 Redistributable' | Out-File $tmpfile -Append
Invoke-WebRequest 'https://download.microsoft.com/download/3/2/2/3224B87F-CFA0-4E70-BDA3-3DE650EFEBA5/vcredist_x64.exe' -OutFile "c:\tmp\vcredist_x64.exe"

timestamp + ' Starting Visual C++ 2010 Redistributable Install'  | Out-File $tmpfile -Append

& "c:\tmp\vcredist_x64.exe" /q /log 'c:\tmp\vcplusplus2010.log' /norestart

timestamp + ' Visual C++ 2010 Redistributable Install Completed' | Out-File $tmpfile -Append

timestamp + ' Downloading Qlik Sense 3.1.1' | Out-File $tmpfile -Append
Invoke-WebRequest 'https://da3hntz84uekx.cloudfront.net/QlikSense/3.1.1/1/_MSI/Qlik_Sense_setup.exe' -OutFile "c:\tmp\Qlik_Sense_setup.exe"

timestamp + ' Starting Qlik Sense Enterprise Install' | Out-File $tmpfile -Append

#& "c:\tmp\Qlik_Sense_setup.exe" -s -l "c:\tmp\qliksenseinstall.log" userwithdomain=$combinedName userpassword=$password dbpassword=$password hostname=$vmname
Start-Process -FilePath 'c:\tmp\Qlik_Sense_setup.exe' -ArgumentList $SenseInstallParams -Credential $Credentials -Wait -RedirectStandardError 'c:\tmp\errorlog.txt'

timestamp + ' Qlik Sense Enterprise Install Completed' | Out-File $tmpfile -Append

#& "c:\tmp\setup.exe" /S
timestamp + ' Adding firewall rule to Windows Firewall to match Azure port configuration' | Out-File $tmpfile -Append

New-NetFirewallRule -DisplayName "Qlik Sense" -Direction Inbound -action Allow -Protocol TCP -LocalPort 80,443,4248,4244 | Out-File $tmpfile -Append

timestamp + ' Firewall Rules added' | Out-File $tmpfile -Append


timestamp + ' Disabling Internet Explorer Security Mode' | Out-File $tmpfile -Append
Disable-InternetExplorerESC