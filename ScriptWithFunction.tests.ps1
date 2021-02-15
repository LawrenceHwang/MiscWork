Describe 'Unit testing the helper functions in self contained script' {
    BeforeAll {
        # Using AST to parse the function definitions from the self contained script.
        # Then, save the script of the Pester test drive.
        $FilePath = Join-Path -Path '.' -ChildPath 'ScriptWithFunction.ps1'
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($FilePath, [ref]$null, [ref]$null)
        $functionDefinition = $ast.FindAll( {
                param([System.Management.Automation.Language.Ast] $AstInput)
                $AstInput -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                # Class methods have a FunctionDefinitionAst under them as well, but we don't want them.
                ($PSVersionTable.PSVersion.Major -lt 5 -or
                    $AstInput.Parent -isnot [System.Management.Automation.Language.FunctionMemberAst])
            },
            $true
        )
        # Write-Host -ForegroundColor Cyan -Object "`tFound [$($functionDefinition.count)] function(s)."
        foreach ($function in $functionDefinition) {
            $functionFilePath = Join-Path -Path 'TestDrive:' -ChildPath "$($function.Name).ps1"
            # Write-Host -ForegroundColor Cyan -Object "`tExporting function to TestDrive: [$($functionFilePath)]"
            $function.Extent.Text | Out-File -FilePath $functionFilePath -Encoding utf8
        }
    }
    Context 'Testing the helper function: Get-MathSquare' {
        $testCase = @(
            @{
                Name   = 'positive number'
                Value  = 4
                Result = 16
            },
            @{
                Name   = 'negative number'
                Value  = -10
                Result = 100
            },
            @{
                Name   = 'zero'
                Value  = 0
                Result = 0
            },
            @{
                Name   = 'one'
                Value  = 1
                Result = 1
            }
        )
        It 'Get-MathSquare should return expected result for [<Name>] input.' -TestCases $testCase {
            param (
                [string]$Name,
                [double]$Value,
                [double]$Result
            )
            . TestDrive:\Get-MathPower.ps1
            . TestDrive:\Get-MathSquare.ps1
            Get-MathSquare -Number $Value | Should -Be $Result
        }
    }
}
