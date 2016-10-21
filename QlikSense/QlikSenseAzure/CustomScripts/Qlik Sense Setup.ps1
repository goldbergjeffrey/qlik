<# Custom Script for Windows #>

$tmpfile = "$env:TEMP\qliktest.txt"

"Environment test" | Out-File $tmpfile -Append
[Environment]::UserName | Out-File $tmpfile -Append
[Environment]::UserDomainName | Out-File $tmpfile -Append
[Environment]::MachineName | Out-File $tmpfile -Append

"Parameter test" | Out-File $tmpfile -Append


Invoke-WebRequest 'https://notepad-plus-plus.org/repository/7.x/7.1/npp.7.1.Installer.x64.exe' -OutFile "$env:TEMP\npp.exe"

& "$env:TEMP\npp.exe" /S
