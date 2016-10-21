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

$vmName | Out-File $tmpfile -Append
$userName | Out-File $tmpfile -Append

# Download QlikSense Setup.exe here!!! (This sample uses Notepad++ as an example)
Invoke-WebRequest 'https://notepad-plus-plus.org/repository/7.x/7.1/npp.7.1.Installer.x64.exe' -OutFile "c:\tmp\setup.exe"

& "c:\tmp\setup.exe" /S
