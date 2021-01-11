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

#endregion



#region WSMan and WMI

# WMI, PSRemoting


#endregion





#region Packaging and Logging

# Commenting
# Logging (streams, files and eventlog)
# Script Libraries and Module Packaging

#endregion