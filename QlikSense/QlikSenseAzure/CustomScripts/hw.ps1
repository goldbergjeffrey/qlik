# If Path doesn't exist then create it
if (-Not (Test-Path "c:\tmp"))
{
	mkdir "c:\tmp"
}

$tmpfile = "c:\tmp\hw.txt"
$config = Get-Content c:\tmp\config.txt

$user = [Security.Principal.WindowsIdentity]::GetCurrent().Name

"Hello " + $user | Out-File $tmpfile -Append

$vmName = $config[0]
$combinedName = $config[1]
$passAsPlainText = $config[2]

$pass = $passAsPlainText | ConvertTo-SecureString
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $combinedName, $pass

$PlainPassword = $Credentials.GetNetworkCredential().Password


if(test-path 'c:\users\qlik' -Credential $Credentials -eq true)
{
	(timestamp) + ' UserProfile for ' + $combinedName + ' exists!' | Out-File $tmpfile -Append
}


(timestamp) + ' Downloading Visual C++ 2010 Redistributable' | Out-File $tmpfile -Append
Invoke-WebRequest 'https://download.microsoft.com/download/3/2/2/3224B87F-CFA0-4E70-BDA3-3DE650EFEBA5/vcredist_x64.exe' -OutFile "c:\tmp\vcredist_x64.exe"

(timestamp) + ' Starting Visual C++ 2010 Redistributable Install'  | Out-File $tmpfile -Append

& "c:\tmp\vcredist_x64.exe" /q /log 'c:\tmp\vcplusplus2010.log' /norestart

(timestamp) + ' Visual C++ 2010 Redistributable Install Completed' | Out-File $tmpfile -Append

(timestamp) + ' Downloading Qlik Sense 3.1.1' | Out-File $tmpfile -Append
Invoke-WebRequest 'https://da3hntz84uekx.cloudfront.net/QlikSense/3.1.1/1/_MSI/Qlik_Sense_setup.exe' -OutFile "c:\tmp\Qlik_Sense_setup.exe"

(timestamp) + ' Starting Qlik Sense Enterprise Install' | Out-File $tmpfile -Append

& "c:\tmp\Qlik_Sense_setup.exe" -s -l "c:\tmp\qliksenseinstall.log" userwithdomain=$combinedName userpassword=$PlainPassword dbpassword=$PlainPassword hostname=$vmname
#Start-Process -FilePath 'c:\tmp\Qlik_Sense_setup.exe' -ArgumentList $SenseInstallParams -Credential $Credentials -Wait -RedirectStandardError 'c:\tmp\errorlog.txt' -LoadUserProfile

(timestamp) + ' Qlik Sense Enterprise Install Completed' | Out-File $tmpfile -Append

#& "c:\tmp\setup.exe" /S

Restart-Computer -Force