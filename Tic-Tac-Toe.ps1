<#

Tic-Tac-Toe

#>

# Initialize game

$header = '-',1,2,3
$TopRow = 'A','-','-','-'
$MidRow = 'B','-','-','-'
$BottomRow = 'C','-','-','-'

$board = @($header,$TopRow,$MidRow,$BottomRow)

function show-board{
    Clear-Host
    $board | ForEach-Object {write-host -Object $_ }

}

function check-win{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        $checksymbol
    )
    
    $checkdiagonal1 = @()
    $checkdiagonal2 = @()
    for([int]$i=1; $i -le 3; $i++){
            #Checking row
            if (!((($board[$i])[1..3] | ForEach-Object {$_ -like $checksymbol}) -contains $false)){
                   write-verbose "win on row $i"
                   return $true
            }

            #Checking column          
            if (!((1..3 | ForEach-Object {$board[$_][$i] -like $checksymbol}) -contains $false)){
                write-verbose "Win on column $i"
                return $true
            }
 
            $checkdiagonal1 += $board[$i][$i] -like $checksymbol
            $checkdiagonal2 += $board[(4-$i)][$i] -like $checksymbol
    }
    
    #Checking diagonal
    if (!($checkdiagonal1 -contains $false) -or !($checkdiagonal2 -contains $false)){
         write-verbose "Win diagonal"
         return $true
    }

    return $false
}

function get-position{
    [cmdletbinding()]
    param(
    [string]$playericon)

    while (!($position -match '^[a-c]{1}[1-3]{1}')){
        show-board
        $position = read-host -prompt "Where would you like to place $playericon"
        if($position -match '^[a-c]{1}[1-3]{1}'){
            if (check-position -position $position){
                Write-Warning 'Not empty spot'
                Start-Sleep 1
                $position = ''
            }
        }
    }
    $position
}

function set-position{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidatePattern('^[a-c]{1}[1-3]{1}')]
        $position,

        [Parameter(Mandatory=$true,
                   Position=1)]
        $playericon
    )

    switch -Regex (($position -split '' | Where-Object {$_})[0]){
        '[aA]' {$px = 1}
        '[bB]' {$px = 2}
        '[cC]' {$px = 3}
    }
    $py = ($position -split '' | Where-Object {$_})[1]
    $board[$px][$py] = $playericon
}

function check-position{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,
                   Position=0)]
        $position
    )

    switch -Regex (($position -split '' | Where-Object {$_})[0]){
        '[aA]' {$px = 1}
        '[bB]' {$px = 2}
        '[cC]' {$px = 3}
    }
    $py = ($position -split '' | Where-Object {$_})[1]

    if (($board[$px][$py] -eq 'X') -or ($board[$px][$py] -eq 'O')){
        $true
    }
    else{
        $false
    }
}


$playerO = 'O'
$playerX = 'X'
$response = ''


# Case1. Human play first.
while (!($response -eq 'y' -or $response -eq 'n'-or $response -eq 'c'-or $response -eq 'cancel')){
    
    #$response = Read-Host -Prompt 'Tic-Tac-Toe: Would you like to play first? [y/n/cancel]'
    
    $response = 'y'

    if($response -eq 'c' -or $response -eq 'cancel'){
        break
    }

}
if ($response -eq 'y'){

}
elseif ($response -eq 'n'){

}

# 2. Show the board


for ($step=1; $step -le 9; $step++){

    if (($step % 2) -eq 1){
        set-position -position (get-position -playericon 'O') -playericon 'O'
        show-board

    }
    else{
        set-position -position (get-position -playericon 'X') -playericon 'X'
        show-board
    }

    if (check-win -checksymbol $playerO){
        write-host "$playerO wins"
        break
    }

    if (check-win -checksymbol $playerX){
        write-host "$playerX wins"
        break
    }

    if ($step -eq 9){
        write-host "Tie!"
        break
    }
}
