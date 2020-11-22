# PSLabs: Session #1
# Doron: AD, Exchange, Platforms, PowerShell: 7
# Idan:  AD, Exchange, Platforms, PowerShell: 8
# Ziv:   AD, Exchange, Citrix, PowerShell: 5
# Dani:  Virtualization, PowerShell: 7-8


#region Commands 
 # Commands:  cmdlets: Verb-Noun, always singular
Get-Service

Get-Command get-service
Get-Command ping

Get-Command get-service -Syntax
get-help get-service
get-service -?
get-help get-service -ShowWindow


get-Command Get-Process -syntax
Get-Process -Name notepad
Get-Process -Id 3736
Get-Process -Name notepad -Id 3736

Get-Process notepad
get-command Get-EventLog -Syntax


get-service wuauservxxxx
stop-service wuauserv -Verbose
get-service wuauserv -Verbose

stop-service wuauserv -Confirm
start-service wuauserv -WhatIf

stop-service wuauserv

# Commands: cmdlet, application, function, alias
get-command -Name ping
get-command -Name clear-host
get-command -Name cls

# transitional aliases:
cls
dir
type 123.txt

clear
ls
cat 123.txt

# shortcut aliases
gci #(Get-ChildItem)
gwmi #(Get-WmiObject)
ft #(Format-Table)


date
Get-Command -Name date
Get-Alias -Name date

get-service bits
service bits


ipconfig
New-Alias -Name ipconfig -Value get-date
# SAFCOG
# Script, Alias, Function, Commandlet, Operable program, Get-
#endregion


#region Variables:

$x = 1
$x
$x.GetType()
$x = "Martin"

Get-Variable
Get-Command -Noun Variable

$date = 123456
$date
$date.GetType()
New-Variable -Name date2 -Value 123456
$date2
$date2.GetType()

Set-Variable -Name date2 -Value 987654

New-Variable -Name date3 -Value 987654 -Option ReadOnly
$date3
$date3 = 65465465464

New-Variable -Name PI -Value 3.14159265 -Option Constant
$PI
$PI = 4

Set-Variable -Name date3 -Value 4 -Force
Set-Variable -Name PI -Value 4 -Force

get-service -Name bits -OutVariable TheBitsService
$TheBitsService

get-service -Name wuauserv -OutVariable $varName
get-service -Name wuauserv -OutVariable dddddd
$varName
$dddddd

$n = 'bits'
get-service $n
get-service 'bits'


$number
$number + 1
1 + 777

'123' + 1
1 + '123'
1 + $number
[int]$number + 1

[int]$num1 = "234234234"
$number + 1

$num2 = [int]'123'
[int]$num3 = '123'


#endregion


#region Operators
$a = 1
$b = 8
$a > $b
echo 12312312 >log.txt
$a = $b

# comparison operators
$a -eq $b
$a -gt $b
$a -lt $b
$a -ne $b

$x = "Hello"
$y = "heLLO"
$x -eq $y
$x -ceq $y
$x -ieq $y

$name = "Martin"
$name -like "*art*"
$name -like "*art??"
$name -like "*arti[a-z]"

$name -clike "*ART*"
$name -inotlike "*ART*"

#endregion


#region Pipline

Get-Process -Name notepad | Stop-Process
Stop-Process -?
get-service -?


Get-Service wuauserv | Start-Service -Confirm
Get-Service win* | Start-Service -Confirm

dir C:\Windows -Recurse | Out-GridView

Get-Process  p* | 
    Sort-Object -Property Handles -Descending | 
        Select-Object -Property ProcessName, Handles, Id | Get-Member
Get-Date

Get-Process  p* | 
    Sort-Object -Property Handles -Descending | 
        Format-Table -Property ProcessName, Handles, Id | Get-Member



Get-Process | Get-Member
dir | Get-Member


Get-Process  p* | 
    Sort-Object -Property Handles -Descending | 
        Select-Object -Property ProcessName, Handles, Id | Export-Csv -Path C:\Temp\PSLabs\1.csv

Get-Process  p* | 
    Sort-Object -Property Handles -Descending | 
        Format-Table -Property ProcessName, Handles, Id | Export-Csv -Path C:\Temp\PSLabs\2.csv
#endregion


#region Conditions, Loops and Arrays

# Conditions, Loops and Arrays

$arr = 1,2,3,4
$arr
$arr.GetType()
$arr.Count
$arr[0]
$arr[2]
$arr[$arr.Count-1]
$arr[-1]
$arr[0,3]

$arr2 = Get-Service
$arr2.Count
$arr2[0]
$arr2[-1]
$arr2[1,4,62,68,233]

$arr -contains 3
3 -in $arr

$arr3 = 1,2,3,4,5,6,7,8,9,10
$arr3 = 1..100

$x = get-service -Name WiaRpc
$x.Status
$x.Status -eq "Stopped"

if($x.Status -eq "Stopped"){ Start-Service $x.Name}


get-service wi* | ForEach-Object {
    if($_.Status -eq 'Stopped') {
        $_
    }
}


get-service wi* | Where-Object { $_.Status -eq 'Stopped' }




get-service wi* | ForEach-Object {
    if($_.Status -eq 'Stopped') {
        Write-Host $_ -ForegroundColor Red
    } else {
        Write-Host $_ -ForegroundColor Green
    }
}


get-service wi* | Where-Object { $_.Status -eq 'Stopped' } | Write-Host -ForegroundColor Red
get-service wi* | Where-Object { $_.Status -ne 'Stopped' } | Write-Host -ForegroundColor Green


(Measure-Command {
    Get-Process | Where-Object { $_.Name -eq 'notepad' } | Select-Object Name, Id
}).TotalMilliseconds

(Measure-Command {
    Get-Process -Name 'notepad' | Select-Object Name, Id
}).TotalMilliseconds


# Filter Left, Format Right
Get-AllUsersFromMyLargeAD | Where-Object { $_.Name -eq 'Martin' } | Enable-User
Get-AllUsersFromMyLargeAD -Name 'Martin' | Enable-User

# List all the dll files that start with z*
get-childitem -Path "C:\windows\system32\*.dll" -include "Z*"

# List the Read only files under c:\Temp\PSLabs
dir C:\Temp\PSLabs
$x = dir C:\Temp\PSLabs\1.csv
$x.Mode
$x.Attributes
$x.IsReadOnly
dir C:\Temp\PSLabs | Where-Object { $_.Mode -like '*r*' }
dir C:\Temp\PSLabs | Where-Object { $_.Attributes -like '*ReadOnly*' }
dir C:\Temp\PSLabs | Where-Object { $_.IsReadOnly }

dir C:\Temp\PSLabs -Attributes 'ReadOnly'
dir C:\Temp\PSLabs -ReadOnly


# Loops

1..10 | ForEach-Object { "number: " + $_ }

for ($i = 1; $i -le 10; $i++) { 
    "number: " + $i 
}

$i = 1
do {
    "number: " + $i 
    $i++
    if($i -gt 5) { break }
}
until ($i -gt 10)


$i = 11
do {
    "number: " + $i 
    $i++ 
}
while ($i -le 10)


$i = 11
while ($i -le 10) {
    "number: " + $i 
    $i++ 
}



Remove-Item C:\Folder -Recurse
do {
    Start-Sleep -Seconds 10
} while (Get-Item C:\Folder)


Stop-Service BITS
do {
    Start-Sleep -Seconds 10
} while ((Get-Service BITS).Status -ne 'Running')


Stop-Service BITS
while ((Get-Service BITS).Status -ne 'Running') {
    Start-Sleep -Seconds 10
}


213213132/1024/1024/1024



#endregion


#region Strings and Files manipulation
#endregion


#region Objects and Registry
#endregion


#region WSMan and WMI
#endregion


#region Packaging and Logging
#endregion