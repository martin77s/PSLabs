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