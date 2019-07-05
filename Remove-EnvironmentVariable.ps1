function Remove-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$VariableName,
        [ValidateSet('machine', 'user')]
        $scope = 'machine'
    )
    process {
        [System.Environment]::SetEnvironmentVariable($VariableName, '', $scope)
    }
}