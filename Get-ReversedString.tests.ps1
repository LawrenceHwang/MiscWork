# dot source the function
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. $here\Get-ReversedString.ps1

Describe 'Reverse string function' {
    $TestString = 'Keep calm and drink coffee'

    It 'Should throw when passing null value' {
        { Get-ReversedString -String $null } | Should -Throw
    }
    It 'Reverses the test string' {
        Get-ReversedString -String $TestString | Should -Be 'eeffoc knird dna mlac peeK'
    }
    It 'Reverses fine when passed in numbers.' {
        $TestNumber = 1234567890
        Get-ReversedString -String $TestNumber | Should -Be '0987654321'
    }
}