 param (    
    [string]$password,
    [string]$username
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
    Write-Output "Installing the web-webserver"
    add-windowsfeature web-webserver -includeallsubfeature -logpath $env:temp\webserver_addrole.log
    Write-Output "Installing web-mgmt-tools"
    add-windowsfeature web-mgmt-tools -includeallsubfeature -logpath $env:temp\mgmttools_addrole.log
    Unzip "C:\Users\Administrator\Downloads\webpage.zip" "C:\inetpub\wwwroot\"
}