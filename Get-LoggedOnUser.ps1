function Get-LoggedOnUser {
    [CmdletBinding()]
    Param(
        [Parameter (Mandatory = $false,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$ComputerName
    )
    Process {
        if ($null -eq $ComputerName) {
            $user = (Get-CimInstance -ClassName Win32_computersystem -Property username -ErrorAction Stop).UserName
            $prop = @{
                'Computer'     = $env:COMPUTERNAME
                'LoggedOnUser' = $user
            }
            $obj = New-Object -TypeName PSObject -Property $prop
            $obj
        } else {
            Foreach ($c in $ComputerName) {
                Try {
                    $AllOK = $true

                    if (Test-Connection -Quiet -ComputerName $c -count 1) {
                        Write-Verbose -message "Checking the logged on user on $c"
                        $user = (Get-CimInstance -ClassName Win32_computersystem -Property username -ComputerName $c -ErrorAction Stop).UserName
                    } else {
                        Write-Verbose -Message "Computer $c is not on the network."
                        $emsg = $c
                        Throw "Can't contact $emsg"
                    }
                } Catch {
                    $AllOK = $false

                    $prop = @{
                        'Computer'     = $c;
                        'LoggedOnUser' = 'N/A'
                    }

                    Write-Verbose -message "Problem with fetching logged on user info."
                    $obj = New-Object -TypeName PSObject -Property $prop
                    Write-Output $obj

                }
                if ($AllOK) {
                    $prop = @{
                        'Computer'     = $c;
                        'LoggedOnUser' = $user
                    }
                    $obj = New-Object -TypeName PSObject -Property $prop
                    $obj
                }
            }
        }
    }
}