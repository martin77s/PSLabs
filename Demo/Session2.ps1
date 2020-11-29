break

# PSLabs: Session #2
# Roee: Platforms, Citrix, AD, PowerShell: 5
# Vova: Virtualization, VMWare, PowerShell: 2-3
# Danny: Platforms, SCCM, AD, PowerShell: 7
# Itamar: AD, Windows core, PowerShell: 6



#region Basics review 
    # 1. Commands and Parameters
    # 2. Variables
    # 3. Operators
    # 4. Pipeline



# Commands:
Get-Command # cmdlet
# Verb-Noun
# Get-Service, New-Service, Stop-Service
Get-Command *service
Get-Command get-command -Syntax

get-command get-process -Syntax
Get-Process -Name notepad
get-process -Id 26496
Get-Process -Name notepad -Id 26496

Get-Process -Name notepad
Get-Process notepad


get-command -Name Get-EventLog -Syntax

Get-EventLog -LogName Application
Get-EventLog Application


# Common cmdlet params
Get-Service wuauserv
Stop-service wuauservddddd

Start-service wuauserv -Verbose
Stop-service wuauserv -Verbose
Get-Service wuauserv -Verbose

get-command stop-service -syntax
Stop-Service wuauserv -Confirm
Stop-Service wuauserv -WhatIf

Get-Service -WhatIf


get-command ping
get-command clear-host
get-command cls

# Alias
# transitional:
cls
clear
dir
ls
type 1.txt
cat 1.txt
get-command cat
get-command get-content -Syntax

# shortcut
get-command notepad
gcm notepad
Get-ChildItem
gci
Get-WmiObject
gmwi

get-alias


# SAFCOG
# Script -> Alias -> Function -> Cmdlet -> Operable program -> Get-
get-alias -Name date
date
get-command -Name date

alias
service
gsv

# This line get all the proccesses that start with s*, and
ps s* | ? { $_ -notin @(0,4) }
Get-Process -Name s* | Where-Object ..


# Variables:
$a = 1
$b = "Martin"
$c = 1.7
$d = Get-service wuauserv
$a
$b
$d
Stop-Service wuauserv
$today = Get-Date

$c.GetType()
$a.GetType()
$b.GetType()

$b = Get-Process

$x = 1
$x = 2

get-command New-Variable -Syntax
get-help New-Variable
New-Variable -?


New-Variable -Name pi -Value 3.14159265 -Option ReadOnly
$pi
$pi = 4
Set-Variable -Name pi -Value 4 -Force

New-Variable -Name pi2 -Value 3.14159265 -Option Constant
$pi2 = 4
Set-Variable -Name pi2 -Value 4 -Force

Set-Variable -Name pi2 -Value 4 -Option ReadOnly
Remove-Variable pi2 -Force

$number + 1
123 + 1
"hello " + "World"
$n = Get-TheNumberOfUsersInAdThat....

$num1 = [int](Get-Num)
$num1 + 1

$num2 = [int]12.34
$num3 = [double]12.34

$num1 = "Martin"

[int]$num4 = 123
$num4 = "qweqweqw"
$num4 = 123.34565

$num4 = "123.34565"


# Operators:
# Comparison
$a = 1
$b = 12
$a > $b
1 > 12

12345 >>1.txt
$a = $b

# equals
# not equals
# grater than
# less than
$a -eq 1
$b -gt 20
$x -ge 10



$name = "martin"
$name -eq "MaRtIn"
$name -ceq "MaRtIn"
$name -ieq "MaRtIn"

"asdasd" -cne "AsdasD"

# Wildcard (Like)
# * = 0-N chars
# ? = 1 char
# [a-z] = range char
"Martin" -like "*art*"
"Martin" -like "*art??"
"Martin" -like "*arti[x-z]"

dir 'C:\Temp\PSLabs\marti`[n`]' -Recurse
dir -Path 'C:\Temp\PSLabs\marti[n]' -Recurse
dir -LiteralPath 'C:\Temp\PSLabs\marti[n]' -Recurse

"Martin" -cnotlike "*arti[x-z]"


# Pipelie:

# cmdlet1 | cmdlet2 | cmdlet3 ......
Get-Service -Name wi* | Select-Object -Property Name, Status, CanShutdown
$x = Get-Service bits
$x.CanShutdown

Get-Service wuauserv | Stop-Service
Stop-Service wuauserv

Get-Service wi* | Stop-Service -WhatIf

# streaming
dir C:\Windows -Recurse | Out-GridView

Get-Process p* | Select-Object -Property ProcessName, Id, Handles | Sort-Object -Property Handles -Descending | Select-Object -First 3
Get-Process p* | Select-Object -Property ProcessName, Id, Handles -First 3 | Sort-Object -Property Handles -Descending
Get-Process p* | Sort-Object -Property Handles -Descending | Select-Object -Property ProcessName, Id, Handles -First 3


$all = Get-Process p* 
$selected = $all | Select-Object -Property ProcessName, Id, Handles 
$sorted = $selected | Sort-Object -Property Handles -Descending 
$top3 = $sorted | Select-Object -First 3
$top3

$sorted


Get-Process p* | 
    Select-Object -Property ProcessName, Id, Handles | 
        Sort-Object -Property Handles -Descending | 
            Select-Object -First 3
Get-Date


Get-Process p* | Select-Object -Property `
ProcessName, Id, Handles | Sort-Object -Property `
 Handles -Descending | Select-Object -First 3


Get-Process p* | 
    Select-Object -Property ProcessName, Id, Handles, BasePriority, MaxWorkingSet | 
        Sort-Object -Property Handles -Descending | 
            Select-Object -First 3 | Format-Table


Get-Process p* | 
    Select-Object -Property ProcessName, Id, Handles, BasePriority, MaxWorkingSet | 
        Sort-Object -Property Handles -Descending |
            Select-Object -First 3 | Format-Table | Get-Member


Get-Process p* | 
    Select-Object -Property ProcessName, Id, Handles, BasePriority, MaxWorkingSet, Description, Company | 
        Sort-Object -Property Handles -Descending |
            Select-Object -First 3 | Export-Csv -Path C:\Temp\1.csv -NoTypeInformation



Get-Service wi*
Get-Service wi* | ft -AutoSize

$FormatEnumerationLimit = -1

#endregion




#region Conditions, Loops and Arrays
$age = 15

if ($age -gt 18)
{
    "Please select a drink"
}


if ($age -gt 18)
{
    "Please select a drink"
}
else
{
    "Call your father"
}


# Verb-Noun
if(-not(Test-Path -Path C:\Temp\1)) {
    New-Item -Path C:\Temp\1 -ItemType Directory
}

if($x -gt 1) {
    "martin"
    start-service bits
    Get-Process
    123/123
}


# () - grouping, if condition, methods
# {} - scriptblock
# [] - array, (syntax = optional)


$s = get-service bits
$s
if($s.Status -ne "running") {
    start-service bits
}


if($s.Status -eq "running") {
} else {
    start-service bits
}


if ($x -gt $y)
{
    
}

$s = get-service bits
$s2 = Get-Service wi*

$s2 | ForEach-Object {
    "Name = " + $_.Name
    "Status = " + $_.Status
}


# PSv2 +
Get-Service wi* | ForEach-Object { $_.Name }

# PSv3 + 
Get-Service wi* | ForEach-Object { $psitem.Name }

# PSv4 + 
Get-Service wi* -PipelineVariable vova | ForEach-Object { $vova.Name }

# Running = green, Stopped = Red
Get-Service wi* | ForEach-Object {
    if ($_.Status -eq "running") {
        Write-Host $_.Name -ForegroundColor Green -BackgroundColor Black
    } elseif($_.Status -eq "stopped") {
        Write-Host $_.Name -ForegroundColor red -BackgroundColor Black
    } else {
        Write-Host $_.Name -ForegroundColor gray -BackgroundColor Black
    }
}


(dir C:\Temp\1.csv).IsReadOnly
(dir C:\Temp\1.json).IsReadOnly

dir C:\Temp\1.json | Get-Member

# List all the read-only files in a folder
dir C:\Temp | ForEach-Object {
    if($_.Mode -like '*r*') {
        $_.Name
    }
}

dir C:\Temp | ForEach-Object {
    if($_.Attributes -like '*ReadOnly*') {
        $_.Name
    }
}


dir C:\Temp | ForEach-Object {
    if($_.IsReadOnly) {
        $_
    }
}

dir C:\Temp -ReadOnly



dir C:\Temp | Where-Object {$_.IsReadOnly}





dir C:\Temp | ForEach-Object {
    if($_.IsReadOnly) {
        "A"
    } else {
        "B"
    }
}
dir C:\Temp | Where-Object {$_.IsReadOnly} | ...
dir C:\Temp | Where-Object {-not $_.IsReadOnly} | ...

(Measure-Command { get-process | Select-Object Name, Id | Where-Object { $_.Name -like 'po*' } }).totalmilliseconds
(Measure-Command { get-process po* | Select-Object Name, Id }).totalmilliseconds

# Filter left, Format right


# Arrays:
$arr = 1,2,3,4
$arr
$arr[0]
$arr[2]
$arr.Count
$arr[3]

$arr2
$arr2.Count
$arr2[$arr2.Count-1]

$arr2[-1]
$arr2[-2]


$arr3 = 1..100
$arr3[1..9]
$arr3[1,5,9]


$s3 = Get-Service
$s3
$s3[0].Status
$s3[-1].DisplayName


$s4 = get-service wi*
$s4.Status -contains "Running"

1,2,3,4,5,6 -contains 5
3 -in 1..10


1,2,35,5,5,5,4,5,6 -eq 5

$arr5 = @()
$arr5 += 1
$arr5 += 2


$x = get-service bits
$x.GetType()
$y = Get-Service wi*
$y.GetType()

$x.Name
$y.name

$x = @(get-service bits)
$x.Count



# Loops:

$services = get-service win*

$services | ForEach { $_ }

foreach($s in $services) {
    $s
}

# streaming
get-service win* | ForEach-Object { $_ }

# downloading
foreach($s in (get-service win*)) {
    $s
}


for($i=1;$i -lt 10;$i++) {
    $i
}

$i = 0
$i
$i = $i + 1
$i++
$i += 4


for ($i = 1; $i -lt 5; $i++) { 
    "item " + $i
}

foreach($i in (1..4)) {
    "item " + $i
}


$services = Get-Service win*
for ($i = 0; $i -lt $services.Count; $i++) { 
    $services[$i].DisplayName
}



$x = 0
do
{
    $x++
    $x
}
until ($x -ge 10)


$x = 100
do
{
    $x++
    $x
}
while ($x -lt 10)


$x = 100
while ($x -lt 10) {
    $x++
    $x
}


# while
Stop-Service bits 
while((Get-Service bits).Status -ne 'Running') {
    Start-Sleep -Seconds 5
}


# do
Stop-Service bits 
do {
    Start-Sleep -Seconds 5
} while ((Get-Service bits).Status -ne 'Running')



# while
Restart-Computer -ComputerName myRemoteServer 
while((Test-Connection -ComputerName myRemoteServer -Count 1) -eq $true) {
    Start-Sleep -Seconds 10
}
copy...


# do
Restart-Computer -ComputerName myRemoteServer 
do {
    Start-Sleep -Seconds 10
} while ((Test-Connection -ComputerName myRemoteServer -Count 1) -eq $true) 




# Targil 2
$bytes = 2453667

<#
if($bytes/1kb -lt 1024) { "bytes" }
elseif($bytes/1mb -lt 1024) { "MB" }
elseif($bytes/1gb -lt 1024) { "GB" }
elseif($bytes/1tb -lt 1024) { "TB" }
#>

$unit = 'bytes','kb','mb','gb','tb','pb','eb','zb'
for ($i = 0; ($bytes -gt 1kb) -and ($i -lt $unit.Count); $i++) { 
    $bytes = $bytes / 1kb
}
"" + $bytes + " " + $unit[$i]



$bytes = 2453667
$unit = 'bytes','kb','mb','gb','tb','pb','eb','zb'
$i = 0
foreach($u in $unit) {
    if($bytes -lt 1kb) { break }
    $bytes = $bytes / 1kb
    $i++
}


$bytes = 2453667
$unit = 'bytes','kb','mb','gb','tb','pb','eb','zb'
$i = 0
while($bytes -gt 1kb) {
    $bytes = $bytes / 1kb
    $i++
}






$unit = 'bytes','kb','mb','gb','tb','pb','eb','zb'
for ($i = 0; ($bytes -gt 1kb) -and ($i -lt $unit.Count); $i++) { 
    $bytes = $bytes / 1kb
}
"" + $bytes + " " + $unit[$i]



# functions:
get-service bits


function f1 {
    get-service bits
}


function f2 {
    Stop-Service wuauserv
}


function Add ($num1, $num2) {
    $num1 + $num2
}

add 2 6
add 9

function Div ($num1, $num2) {
    if($num2 -ne $null) {
        $num1 / $num2
    }
}

div 2 8
div 9


function Div2 ($Mone, $Mechane = 1) {
    $Mone / $Mechane
}


Div2 -Mechane 4 -Mone 2



function Get-FriendlySize ($bytes) {
    $unit = 'bytes','kb','mb','gb','tb','pb','eb','zb'
    for ($i = 0; ($bytes -gt 1kb) -and ($i -lt $unit.Count); $i++) { 
        $bytes = $bytes / 1kb
    }
    "" + $bytes + " " + $unit[$i]
}



#endregion




#region Strings and Files manipulation
#endregion




#region *-content, *-item
#endregion




#region Objects and Registry
#endregion




#region WSMan and WMI
#endregion




#region Packaging and Logging
#endregion


