 param (
    [string]$dbserver,
    [securestring]$password,
    [string]$username,
    [string]$zipfile
 )

Add-Type -AssemblyName System.IO.Compression.FileSystem

##  Create user and add to Administrators group
$pass = ConvertTo-SecureString $password -AsPlainText -Force
New-LocalUser -Name $username -Password $pass -PasswordNeverExpires
Add-LocalGroupMember -Group \"Administrators\" -Member $username

## Functions
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

##  Check if we are the DB server or are a webserver ...
$serverType = $(Test-Path C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\SQLCMD.EXE)

if ($serverType -eq $True) {
    ## Then we are the database server
}
else {
    ## Then we are a webserver
    Unzip "C:\a.zip" "C:\inetpub\wwwroot\"
}