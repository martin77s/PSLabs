#region Review

$a = 'b'
$b = 'c'
$c = 'd'

Remove-Variable -Name $b
Remove-Variable -Name 'c'

$n = 'bits'
Get-service -Name $n


Get-Process -OutVariable $n
Get-Process -OutVariable 'bits'
$n
$bits


$allUsersInAd = Get-AllUsersInAd
Get-AllUsersInAd -Ov allUsersInAd


function Get-AllUsersInAd {
    [cmdletbinding()]
    param()
    "1"
    "2"
    "3"
    throw 'ERROR'
    "4"
    "5"
}

$b = Get-Service bits
$b.Status

$b.Status -eq 'Running'
4 -eq $b.Status

$b.Status.GetType()

[System.ServiceProcess.ServiceControllerStatus]::Running

$b.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running


# For vs. (ForEach vs. ForEach-Object)

$service = Get-Service
for ($i = 0; $i -lt $service.Count; $i++) { 
    "$i) " + $service[$i].Name
}


$i = 0
$service = Get-Service
foreach($s in $service) {
    "$i) " + $s.Name    
    $i++
}



(Measure-Command {
    for ($i = 0; $i -lt (Get-Service).Count; $i++) { 
        (Get-Service)[$i].Name
    }
}).TotalMilliseconds


(Measure-Command {
    foreach($s in (Get-Service)) {
        $s.Name    
    }
}).TotalMilliseconds



# Downloading
foreach($s in (Get-Service n*)) {
    $s.Name
}

# Streaming
Get-Service n* | ForEach-Object {
    $_.Name
}


# Downloading
foreach($s in (Get-Service n*)) {
    if($s.Name -eq 'Netlogon') { break }
    $s.Name
}


# Streaming
Get-Service n* | ForEach-Object {
    if($_.Name -eq 'Netlogon') { break }
    $_.Name
}


Get-Process | ForEach-Object {
    $_.Modules | ForEach-Object {
        if($_.FileName -like '*appdata\local\temp*') {
            $_
        }
    }
}


Get-Process | ForEach-Object {
    $thisProcess = $_
    $_.Modules | ForEach-Object {
        if($_.FileName -like '*appdata\local\temp*') {
            $thisProcess
        }
    } | Select-Object -Unique
}


Get-Process -PipelineVariable thisProx | ForEach-Object {
    $_.Modules | ForEach-Object {
        if($_.FileName -like '*appdata\local\temp*') {
            $thisProx
        }
    } | Select-Object -Unique
}

#endregion


#region Regex

# ^ = Start of the string
# \w{1,}  = quantifier, more than 1 word char
# \w{1,3} = quantifier, between 1 and 3 chars
# +       = quantifier, 1 or more
# *       = quantifier, 0 or more
# ?       = quantifier, 0 or 1
# \s      = space
# \d      = digits
# ()      = grouping
# |       = or
# .       = any char
# ?<name> = name a group

$pattern = '^(?<FirstName>\w+)\s+(?<LastName>\w+)\s+(?<Tel>(?<Kidomet>\d{2,3})(-|\.)(?<Number>\d{7,8}))$'

'!22 89769887-98' -match $pattern
'qweqwseqsw ! 89769887-98' -match $pattern
'Martin Schvartzman  050-77441122' -match $pattern
'Moshe    Choen 03-88441177' -match $pattern
'David Levi 7mailman' -match $pattern
'David Levi 09-7788963d' -match $pattern
'Yana  Katz 052.7534458' -match $pattern

'https://www.martin.com' -match 'http|https'
'https://www.martin.com' -match 'http(s?)'

$Matches

$Matches.FirstName
$Matches.LastName


$content = gc "C:\gitRepos\PSLabs\Labs\iis.log"
# 2013-07-30 00:00:08 SOME1234NAME 10.10.10.100 GET /some/image/path/something.jpg - 80 - 22.22.22.200 Mozilla/5.0+(Windows+NT+5.1;+rv:10.0)+Gecko/20100101+Firefox/10.0 200 0 0

$pattern = '^(?<DateTime>(?<date>\d{4}-\d{2}-\d{2})\s+(?<time>\d{2}:\d{2}:\d{2}))\s+(?<ComputerName>\w+)\s+.*(?<Method>GET|POST)\s(?<Url>.*)\s(.*)\s(\d+)\s-'

$output = $content | ForEach-Object {
    if($_ -match $pattern) {
        [PSCustomObject]@{
             DateTime     = $Matches.DateTime
             ComputerName = $Matches.ComputerName
             Method       = $Matches.Method
             Url          = $Matches.url
             Segments     = ($Matches.url -split '/').Count -1
        }
    }
}

$output | Where-Object { $_.Segments -gt 3 } | Select-Object Url, Method, Segments

#endregion



#region WSMan and WMI

# WMI, PSRemoting


Get-WmiObject -List *service*
gwmi Win32_Service 


Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | Select-Object  Index, ServiceName, Description,IPAddress
$primaryNic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.DefaultIPGateway }


$wql = "SELECT Index, ServiceName, Description,IPAddress FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled='TRUE'"
Get-WmiObject -Query $wql | Select-Object Index, ServiceName, Description,IPAddress

$filter = "IPEnabled='TRUE'"
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter $filter | Select-Object Index, ServiceName, Description, IPAddress



Get-WmiObject -CN DC -Class Win32_BIOS

Get-WmiObject -CN DC -Class Win32_ComputerSystem

Get-WmiObject -CN DC -Class Win32_OperatingSystem

Get-WmiObject -CN DC -Class Win32_NetworkAdapterConfiguration

 

$sessOptionWsMan = New-CimSessionOption -Protocol Wsman

$session = New-CimSession -ComputerName DC -SessionOption $sessOptionWsMan

Get-CimInstance -CimSession $session -ClassName Win32_BIOS

Get-CimInstance -CimSession $session -ClassName Win32_Service

Remove-CimSession -CimSession $session

# 5985/6 (http/s)

# Enable-PSRemoting # As Admin! (OS Clients, OS Server < 2012)

# FW WSMAN, Listner, Service WinRM start + auto

Enable-PSRemoting

 

$cred = (Get-Credential)

# 1:1

get-service bits

Invoke-Command -ComputerName MS -ScriptBlock { get-service bits } -Credential $cred

Invoke-Command -ComputerName MS,DC -ScriptBlock { get-service bits } -Credential $cred

 

$s1 = get-service bits

$s2 = Invoke-Command -ComputerName MS -ScriptBlock { get-service bits }

$s3 = Invoke-Command -ComputerName localhost -ScriptBlock { get-service bits }

 

$s1.GetType()

$s3.GetType()

 

 

$b1 = get-service bits

$b1 | Export-Clixml -Path C:\Temp\PSLabs\bits.xml

$b1 | gm

 

$b2 = Import-Clixml -Path C:\Temp\PSLabs\bits.xml

$b2 | gm

 

 

 

 

Invoke-Command -ComputerName MS -ScriptBlock { $a = Get-Date }

Invoke-Command -ComputerName MS -ScriptBlock { $a } # Nothing

 

Invoke-Command -ComputerName MS -ScriptBlock { $a = Get-Date; $a }

$a = Invoke-Command -ComputerName MS -ScriptBlock { Get-Date }

 

 

$session = New-PSSession -ComputerName MS

Invoke-Command -Session $session -ScriptBlock { $a = Get-Date }

Invoke-Command -Session $session -ScriptBlock { $a }

Invoke-Command -Session $session -ScriptBlock { $p = Start-Process -FilePath notepad.exe -PassThru }

Invoke-Command -Session $session -ScriptBlock { $p }

Invoke-Command -Session $session -ScriptBlock { $p.Close() }

 

# 1:1 interactive

Enter-PSSession -ComputerName DC

Exit-PSSession

 

Enter-PSSession -Session $session

 

 

# 1:many

$computers = Get-Content C:\Users\power\desktop\computers.txt

Invoke-Command -ComputerName $computers -ScriptBlock { hostname } -ThrottleLimit 1

 

Invoke-Command -ComputerName $computers -ScriptBlock { ipconfig.exe /flushdns }

Invoke-Command -ComputerName $computers -ScriptBlock { Invoke-Expression "echo n | gpupdate /force" }



function Get-SharePermisionsReport {
    param(
        $ComputerName = $env:COMPUTERNAME,
        [Switch]$ShowHiddenShares
    )
    foreach ($computer in $ComputerName) {
        if(Test-Connection -ComputerName $computer -Quiet -Count 1) {
        #if(Test-NetConnection -ComputerName $computer -CommonTCPPort SMB) {
        #if(Test-NetConnection -ComputerName $computer -CommonTCPPort WINRM) {
            $shares = Get-WmiObject -ComputerName $computer -Class Win32_Share
            #$shares = Get-CimInstance -ComputerName $ComputerName -ClassName Win32_Share
            $shares | Where-Object { $ShowHiddenShares -or ($_.Name -notlike '*$') } -PipelineVariable share | ForEach-Object {
                $remotePath = '\\{0}\{1}' -f $computer, ($_.Path -replace ':', '$')
                (Get-Acl -Path $remotePath).AccessToString.Split([System.Environment]::NewLine) | ForEach-Object {
                    New-Object -TypeName PSObject -Property @{
                        ComputerName = $computer
                        ShareName    = $share.Name
                        LocalPath    = $share.Path
                        RemotePath   = $remotePath
                        NTFS         = $_
                    }
                }
            }
        }
    }
} 

#Get-SharePermisionsReport -ComputerName qweqeqw
Get-SharePermisionsReport #-ComputerName 'localhost', '127.0.0.1', $env:COMPUTERNAME
$computer = $env:COMPUTERNAME
#endregion



$cred = New-Object -TypeName pscredential -ArgumentList @(
    'user'
    'P@55w0rd?' | ConvertTo-SecureString -AsPlainText -Force
)

$cred | Export-Clixml -Path C:\Temp\PSLabs\cred.xml


$importedCreds = Import-Clixml -Path C:\Temp\PSLabs\cred.xml
$importedCreds.GetNetworkCredential().Password
New-PSDrive -Name T -PSProvider FileSystem -Root "\\$env:COMPUTERNAME\c$" -Credential $importedCreds



#region Encrypt / Decrypt Text Using CMS

# Get the script content as string:
$scriptContent = Get-Content -Path C:\Temp\plainTextScript.ps1

# Create the certificate:
$cert = New-SelfSignedCertificate -DnsName PSCms -CertStoreLocation Cert:\CurrentUser\my `
    -KeyUsage KeyEncipherment, DataEncipherment, KeyAgreement -Type DocumentEncryptionCert

# Encrypt message:
$scriptContent | Protect-CmsMessage -To $cert -OutFile C:\Temp\encryptedScript.txt

# Verify the encrypted contents:
notepad C:\Temp\encryptedScript.txt

# Export the certificate:
$certPassword = 'Password1' | ConvertTo-SecureString -AsPlainText -Force
Export-PfxCertificate -Cert $cert -FilePath C:\Temp\CMS.pfx -Password $certPassword


# *** on the thinClient  ***
# Import the certificate once:
$certPassword = 'Password1' | ConvertTo-SecureString -AsPlainText -Force
Import-PfxCertificate -FilePath C:\Temp\CMS.pfx -CertStoreLocation Cert:\CurrentUser\My -Password $certPassword

# Decrypt message (The cert needs to be installed on the machine):
$plainTextcode = Unprotect-CmsMessage -Path C:\Temp\encryptedScript.txt

# Invoke the code:
Invoke-Expression -Command $plainTextcode
