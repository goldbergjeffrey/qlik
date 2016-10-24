# If Path doesn't exist then create it
if (-Not (Test-Path "c:\tmp"))
{
	mkdir "c:\tmp"
}

$tmpfile = "c:\tmp\hw.txt"

$user = [Security.Principal.WindowsIdentity]::GetCurrent().Name

"Hello " + $user | Out-File $tmpfile -Append

Restart-Computer