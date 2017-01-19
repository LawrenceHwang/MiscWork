<#

Tic-Tac-Toe

#>

Function get-nextStep{


}


# Initialize game

$header = '-',1,2,3
$TopRow = 'A','X','X','X'
$MidRow = 'B','-','X','-'
$BottomRow = 'C','-','-','X'

$board = @($header,$TopRow,$MidRow,$BottomRow)

function show-board{

    $board | ForEach-Object {Write-Host -Object $_ }

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
            if (!((($board[$i])[1..3] | foreach {$_ -like $checksymbol}) -contains $false)){
                   Write-host "Win on row $i"
            }

            #Checking column          
            if (!((1..3 |foreach {$board[$_][$i] -like $checksymbol}) -contains $false)){
                Write-host "Win on column $i"
            }
 
            $checkdiagonal1 += $board[$i][$i] -like $checksymbol
            $checkdiagonal2 += $board[(4-$i)][$i] -like $checksymbol
    }
    
    #Checking diagonal
    if (!($checkdiagonal1 -contains $false) -or !($checkdiagonal2 -contains $false)){
         Write-host "Win diagonal"
    }
}



$player1 = 'X'
$player2 = 'O'
$response = ''


# 1. Ask if human want to play first.



while (!($response -eq 'y' -or $response -eq 'n'-or $response -eq 'c'-or $response -eq 'cancel')){
    
    $response = Read-Host -Prompt 'Tic-Tac-Toe: Would you like to play first? [y/n/cancel]'
    
    if($response -eq 'c' -or $response -eq 'cancel'){
    break
}

}


if ($response -eq 'y'){

}
elseif ($response -eq 'n'){

}


show-board
check-win -checksymbol $player1


$player1Position = 'B2'

$player2Position



