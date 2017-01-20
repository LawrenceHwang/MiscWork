function Get-LoggedOnUser {
    [CmdletBinding()]

    Param(
        [Parameter (Mandatory=$true,
            ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$ComputerName
    )

    Begin{
    }
    Process{
        Foreach ($c in $ComputerName){
            Try{
                $AllOK = $true

                if (Test-Connection -Quiet -ComputerName $c -count 2){
                    
                    write-verbose -message "Checking the logged on user on $c"
                    $user = (Get-WmiObject -Class Win32_computersystem -Property username -ComputerName $c -ErrorAction Stop).Username
                }
                else {
                    Write-Verbose -Message "Computer $c is not on the network."
                    $emsg = $c
                    Throw "Can't contact $emsg"
                }
            }
            Catch{
                $AllOK = $false

                $prop = @{'Computer'=$c;
                    'LoggedOnUser'='N/A'
                }

                write-verbose -message "Problem with fetching logged on user info."
                $obj = New-Object -TypeName PSObject -Property $prop
                Write-Output $obj

            }
            Finally{
            }

            if ($AllOK){
                   
                $prop = @{'Computer'=$c;
                    'LoggedOnUser'=$user
                }

                $obj = New-Object -TypeName PSObject -Property $prop
                Write-Output $obj
            }
        }
    }
    End{
    }
}