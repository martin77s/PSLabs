break

#region review

$a = 'b'
$b = 'c'
$c = 'd'

Remove-Variable -Name $b
Remove-Variable -Name 'c'

$n = 'bits'
get-service -Name $n


get-service wuauserv -OutVariable $n
$n
$bits

get-service wuauserv -OutVariable 'bits'
get-service wuauserv -OutVariable $mxmxmxmxm
$mxmxmxmxm


Get-Process -OutVariable all | Where { $_.BasePriority -gt 4 } -OutVariable filtered | asdadas | adadas | adas 
$all
$filtered


($a = get-service bits)


$allUsers1 = Get-AllUsersInAd
Get-AllUsersInAd -OutVariable allUsers2
$allUsers2


function Get-AllUsersInAd {
    [cmdletbinding()]
    param()
    "1"
    "2"
    "3"
    throw 'Error'
    "4"
    "5"
}


$b = Get-Service -Name bits
$b.Status

$b.Status -eq 'Running'

4 -eq $b.Status

$b.Status.value__
$b.Status.GetType()

[System.ServiceProcess.ServiceControllerStatus]::ContinuePending.value__

$b.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running

enum sss {
    Running = 4
    ContinuePending = 5
}

[sss]::ContinuePending


[System.Enum]::GetValues('System.ServiceProcess.ServiceControllerStatus') | % {
    '{0} = {1}' -f $_, [int]([System.ServiceProcess.ServiceControllerStatus]$_)
}


get-process | ForEach-Object {
    $p = $_
    $_.Modules | ForEach-Object {
        if($_.FileName -like '*appdata\local\temp*') {
            $p
        }
    } | Select-Object -Unique
}



Get-Process -PipelineVariable itamar | ForEach-Object {
    $_.Modules | ForEach-Object {
        if($_.FileName -like '*appdata\local\temp*') {
            $itamar
        }
    } | Select-Object -Unique
}


ps -id $pid | select -expand Modules

#endregion


#region RegEx

# .       = any char
# \       = escape char
# \d      = digit
# \s      = space
# \w      = word
# {X}     = quantifier - exactly X
# {X,Y}   = quantifier - from X to Y
# {X,}    = quantifier - atleast X
# {1,}    = quantifier - atleast 1
# +       = quantifier - atleast 1
# {0,}    = quantifier - atleast 0
# *       = quantifier - atleast 0
# ^       = start of the string
# $       = end of the string
# ()      = grouping
# |       = or
# ?<name> = naming a group
# ?       = quantifier 0,1

'https://www.bing.com' -match 'http(s?)'
'https://www.bing.com' -match '(ht|f)tp(s?)'


$pattern = '^(?<FirstName>\w+)\s+(?<LastName>\w+)\s+(?<Tel>(?<Kidomet>\d{2,3})(-|\.)(?<Num>\d{7,8}))$'
$pattern = '^(\w+)\s+(\w+)\s+(\d{2}(-|\.)\d{8}|\d{3}(-|\.)\d{7}$)$'

'Martin     Schavzrtman 050-7744112' -match $pattern 
'Dana  Nama 03.38844112' -match $pattern 

$Matches
if($?) {
    New-Object -TypeName PSObject -Property @{
        DisplayName = $Matches.FirstName + ' ' + $Matches.LastName
        FirstName = $Matches.FirstName
        LastName = $Matches.LastName
        Tel = $Matches.Tel
    }
}


### LAB ###


function Parse-IisLog {
    param($LogFile = 'C:\gitRepos\PSLabs\Labs\iis.log')
    $pattern = '^(?<dateTime>(?<date>\d{4}-\d{2}-\d{2})\s(?<time>\d{2}:\d{2}:\d{2}))\s(?<computerName>\S+)\s(\S+)\s(?<Method>\w+)\s(?<Url>\S+)\s'

    '190.10.100.500' -match '(\d{1,3}\.){3}\d{1,3}'

    #Get-Content -Path C:\gitRepos\PSLabs\Labs\iis.log | ? { $_ -notlike '#*' } | ForEach-Object {
    Get-Content -Path $LogFile | ForEach-Object {
        if($_ -match $pattern) {
            # $Matches.Remove(0)
            # New-Object -TypeName PSObject -Property $Matches
            [pscustomobject]@{
                #DateTime     = (Get-Date $Matches.dateTime)
                DateTime     = [datetime]$Matches.dateTime
                ComputerName = $Matches.computerName
                Method       = $Matches.Method
                Url          = $Matches.Url
                Segments1     = ($Matches.Url -split '/').Count -1
                Segments2     = ($Matches.Url.ToCharArray() -eq '/').Count
            }
        }
    }
}

Parse-IisLog | ? { $_.Segments1 -eq 3 }
Parse-IisLog | ? { $_.DateTime -gt (Get-Date -Date '2013/07/30 00:00:10') }


#endregion

#region WMI and WSMAN


### WMI


Get-WmiObject -List *service*
Get-WmiObject -List *proces*


Get-WmiObject -Class win32_service | Select-Object -f 1 -pr *

$x = [wmi]'\\MASCHVAR-T480\root\cimv2:Win32_Service.Name="bits"'
$x | Get-Member
$x.__PATH

$dt = Get-WmiObject win32_operatingsystem 
$dt.ConvertToDateTime($dt.LastBootUpTime)



Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ogv


Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" | ogv


Get-WmiObject -Query "select * from Win32_NetworkAdapterConfiguration where IPEnabled='True'" | ogv




Get-WmiObject -Property DHCPEnabled, IPAddress -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'"
Get-WmiObject -Query "select DHCPEnabled, IPAddress from Win32_NetworkAdapterConfiguration where IPEnabled='True'" 



$p = [wmiclass]"\\MASCHVAR-T480\root\cimv2:Win32_Process"
$p.Create('notepad.exe')



$p = [wmiclass]"\DC\root\cimv2:Win32_Process"

$p.Create('notepad.exe')

 

Get-WmiObject -Class Win32_ComputerSystem -ComputerName 192.168.1.2

 

 

Get-Content "C:\Users\power\Desktop\computers.txt" | % {

   #if(Test-Connection -ComputerName $_ -Count 1 -Quiet) {

   #if(Test-NetConnection -ComputerName $_ -CommonTCPPort SMB) {

       gwmi win32_computersystem -cn $_ -AsJob | Wait-Job -Timeout 4 | Receive-Job

   #}

}

 

Start-Job -ScriptBlock { dir c:\ -Recurse }

 

$s = gwmi win32_service -fil "name='Winmgmt'" -cn Dc

 

 

 

## CIM

# DCOM = 445 (RPC)

# WSMAN = 5985/6 (WINRM)

 

$dt = Get-WmiObject win32_operatingsystem -ComputerName MS

$dt.ConvertToDateTime($dt.LastBootUpTime)

 

$dt2 = Get-CimInstance -ClassName win32_operatingsystem -ComputerName MS

$dt2.LastBootUpTime

 

 

 

$options = New-CimSessionOption -Protocol Wsman # | dcom

$session = New-CimSession -ComputerName MS -SessionOption $options

Get-CimInstance -ClassName win32_process -CimSession $session

 

 

Get-CimInstance -CimSession (New-CimSession -ComputerName MS -SessionOption `

   (New-CimSessionOption -Protocol Wsman)) -ClassName Win32_BIOS

 

Get-CimInstance -CimSession (New-CimSession -ComputerName MS -SessionOption `

   (New-CimSessionOption -Protocol Dcom)) -ClassName Win32_BIOS

 

 

Invoke-Command { start-service winrm } -cn MS

 

$s = [wmi]"\ms\root\cimv2:win32_service.Name='winrm'"

$s.StartService()


## PSRemoting

# 5985/6

# Windows Server < 2012 || Windows Client OS

Enable-PSRemoting

# Enable FW rules, Service WINRM start + auto, httplistner

 

$cred = Get-Credential

# 1:1:

Invoke-Command -ComputerName MS -Credential $cred -ScriptBlock { hostname }

 

Get-service BITS

Invoke-Command -ComputerName MS,DC -Credential $cred -ScriptBlock { Get-service BITS }

 

$s1 = get-service bits

$s2 = Invoke-Command -ComputerName DC -Credential $cred -ScriptBlock { Get-service BITS }

 

$s1 | gm

$s2 | gm

 

Get-Service BITS | Export-Clixml C:\temp\3.xml

notepad C:\temp\3.xml

$s3 = Import-Clixml C:\temp\3.xml

$s3

 

 

 

Invoke-Command -ComputerName DC -ScriptBlock { $d = get-date }

Invoke-Command -ComputerName DC -ScriptBlock { $d }

 

 

Invoke-Command -ComputerName DC -ScriptBlock { $pid }

 

 

# 1:1 persistent

$pssession = New-PSSession -ComputerName DC

 

Invoke-Command -Session $pssession -ScriptBlock { $d = get-date }

Invoke-Command -Session $pssession -ScriptBlock { $d }

 

 

# 1:1 interactive

Enter-PSSession -Session $pssession

Exit-PSSession

Invoke-Command -Session $pssession -ScriptBlock { $x }

 

 

# 1:many

$computers = get-content 'C:\Users\power\Desktop\computers.txt'

Invoke-Command -ComputerName $computers -ScriptBlock { hostname }

 

$response = Invoke-Command -ComputerName $computers -ScriptBlock { hostname } -ThrottleLimit 1

 

$computes | % {

   Invoke-Command -ComputerName $_ -ScriptBlock { hostname }

   if($?) { .. }

}

 

# Real life examples

Invoke-Command -ComputerName $computers -ScriptBlock { ipconfig.exe /flushdns }

 

Invoke-Command -ComputerName $computers -ScriptBlock { invoke-expression 'echo n| gpupdate /force' }

 

 

# Implicit remoting

$s = New-PSSession -ComputerName DC

Invoke-Command -Session $s -ScriptBlock { Import-Module ActiveDirectory }

Import-PSSession -Session $s -Module ActiveDirectory -Prefix vvv

Get-vvvADUser -Filter *

 

gc function:Get-vvvADUser | clip


#endregion


#Splatting:

Get-WmiObject -Namespace 'root\cimv2' -ComputerName $env:COMPUTERNAME -Class 'Win32_NetworkAdapterConfiguration' -Filter "IPEnabled='True'" -ThrottleLimit 1 -Impersonation Impersonate -Authentication PacketPrivacy

Get-WmiObject `
    -Namespace 'root\cimv2' `
    -ComputerName $env:COMPUTERNAME `
    -Class 'Win32_NetworkAdapterConfiguration' `
    -Filter "IPEnabled='True'" `
    -ThrottleLimit 1 `
    -Impersonation Impersonate `
    -Authentication PacketPrivacy


$paramsWmiQ = @{
    Namespace      = 'root\cimv2'
    Class          = 'Win32_NetworkAdapterConfiguration'
    Filter         = "IPEnabled='True'"
    ThrottleLimit  = 1 
    Impersonation  = 'Impersonate'
    Authentication = 'PacketPrivacy'
}
Get-WmiObject @paramsWmiQ -ComputerName $env:COMPUTERNAME
Get-WmiObject @paramsWmiQ -ComputerName 'localhost'