<#
.Synopsis
   A Powershell function to generate elementary school level (grade 1 - grade 3) math addition and substraction quesitons.
.DESCRIPTION
   This PowerShell function generate random math questions.
   I write this function so I can easier get some questions to work with my kids.
.EXAMPLE
This example gets default 10 easy questions.

   PS C:\Users\l> Get-MathQuestion
    14 + 27 = __________
    19 - 19 = __________
    2 + 12 = __________
    19 - 2 = __________
    19 - 15 = __________
    29 + 4 = __________
    10 + 7 = __________
    4 - 2 = __________
    21 - 20 = __________
    27 + 4 = __________
.EXAMPLE
This example gets five hard questions with answers.

   PS C:\Users\l> Get-MathQuestion -NumberOfQuestion 5 -Diffuculty hard -ShowAnswer
    6780 - 6611 = __________                  Answer: 169
    1846 + 5538 = __________                  Answer: 7384
    7474 - 1285 = __________                  Answer: 6189
    3986 + 4445 = __________                  Answer: 8431
    4708 + 1026 = __________                  Answer: 5734
.EXAMPLE
This example gets 10 medium questions and saves it into the $question variable.
Then a banner is attached.
Finally, the banner and the qestions are sent to the default printer via out-printer.

$banner = @'
_.----.        ____         ,'  _\   ___    ___     ____
_,-'       `.     |    |  /`.   \,-'    |   \  /   |   |    \  |`.
\      __    \    '-.  | /   `.  ___    |    \/    |   '-.   \ |  |
 \.    \ \   |  __  |  |/    ,','_  `.  |          | __  |    \|  |
   \    \/   /,' _`.|      ,' / / / /   |          ,' _`.|     |  |
    \     ,-'/  /   \    ,'   | \/ / ,`.|         /  /   \  |     |
     \    \ |   \_/  |   `-.  \    `'  /|  |    ||   \_/  | |\    |
      \    \ \      /       `-.`.___,-' |  |\  /| \      /  | |   |
       \    \ `.__,'|  |`-._    `|      |__| \/ |  `.__,'|  | |   |
        \_.-'       |__|    `-._ |              '-.|     '-.| |   |
                                `'                            '-._|



'@

$question = Get-MathQuestion -NumberOfQuestion 10 -Diffuculty medium
$question = [string]::join("`n`n`n`n", $question)
($Banner + $question)| Out-Printer
.NOTES
   Author: Lawrence Hwang
   Twitter: @cpoweredlion
.FUNCTIONALITY
   Output random math questions.
#>
function Get-MathQuestion {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 100)]
        [int]$NumberOfQuestion = 10,

        [ValidateSet('easy', 'medium', 'hard')]
        [string]$Diffuculty = 'easy',

        [switch]$ShowAnswer
    )

    switch ($Diffuculty) {
        easy {
            $max = 30
            $min = 1
        }
        medium {
            $max = Get-Random -Maximum 999 -Minimum 300
            $min = Get-Random -Maximum 200 -Minimum 1
        }
        hard {
            $max = Get-Random -Maximum 9999 -Minimum 2000
            $min = Get-Random -Maximum 1999 -Minimum 300
        }
    }

    for ($i = 1; $i -le $NumberOfQuestion ; $i = $i + 1) {
        $operater = '-', '+' | Get-Random
        $numberA = $(Get-Random -Maximum $max -Minimum $min)
        $numberB = $(Get-Random -Maximum $max -Minimum $min)

        switch ($operater) {
            # Currently, I am only including addition and substraction for kids.
            # Later we can get multipacation and division in here if we want.
            # Or better yet, separate them into different private fucntions. ;)
            '-' {
                # This is to prevent the negative number in substractions.
                if ($numberA -lt $numberB) {
                    $t = $numberA
                    $numberA = $numberB
                    $numberB = $t
                    $t = $null
                }
                $answer = $numberA - $numberB
            }
            '+' {
                $answer = $numberA + $numberB
            }
        }
        if ($ShowAnswer) {
            # Well... use only when needed. Find the answers together with kids is fun.
            Write-Output "$numberA $operater $numberB = __________                  Answer: $answer"
        } else {
            # I am doing text output because I plan to print this as worksheet and let kids write the questions.
            Write-Output "$numberA $operater $numberB = __________ "
        }
    }
}