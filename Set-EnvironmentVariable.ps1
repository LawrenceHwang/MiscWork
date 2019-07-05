function Set-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$VariableName,
        [Parameter(Mandatory)]
        [string]$VariableValue,
        [ValidateSet('machine', 'user')]
        $scope = 'machine'
    )
    process {
        [System.Environment]::SetEnvironmentVariable($VariableName, $VariableValue, $scope)
    }
}