Function Get-SSLCertificate {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true,
            ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$URI,
        [int]$TCPPort = 443,
        [int]$Timeoutms = 4000
    )

    begin {
        if ($URI -match '^https://') {
            $URI = $URI -replace ('https://', '')
        }
        Write-Verbose "Parsed URI is $URI"
    }

    process {
        foreach ($U in $URI) {
            $port = $TCPPort
            Write-Verbose "$U`: Connecting on port $port"
            [Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
            $req = [Net.HttpWebRequest]::Create("https://$U`:$port")
            Write-Verbose "Trying"
            $req.Timeout = $Timeoutms
            try {

                $req.GetResponse() | Out-Null
            }

            catch {
                if (!($req.ServicePoint.Certificate)) {
                    Write-Verbose "Couldn't connect to $U on port $port"
                    Write-Error "$U`: No Certificate returned."
                    break
                } else {
                    # Cert still received.

                }
            }

            if (!($req.ServicePoint.Certificate)) {
                Write-Error "No Certificate returned on $U"
            }

            $certinfo = $req.ServicePoint.Certificate
            Write-Verbose "$certinfo"

            $returnobj = [ordered]@{
                URI          = $U;
                Port         = $port;
                Subject      = $certinfo.Subject;
                Thumbprint   = $certinfo.GetCertHashString();
                Issuer       = $certinfo.Issuer;
                SerialNumber = $certinfo.GetSerialNumberString();
                Issued       = $certinfo.GetEffectiveDateString();
                Expires      = $certinfo.GetExpirationDateString();
            } #end of returnobj

            $obj = New-Object PSCustomObject -Property $returnobj

            return $obj
        } #end of foreach
    }#end of process{}

    end { }

} #end of function