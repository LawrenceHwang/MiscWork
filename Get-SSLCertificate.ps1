function Get-SSLCertificate{
    [CmdletBinding()]
    param(
            [parameter(Mandatory=$true,
                        ValueFromPipeline)]
            [string[]]$URI,
            [int]$TCPPort=443,
            [int]$Timeoutms=4000
    )

    begin{
        if ($URI -match '^https://'){
            $URI = $URI -replace ('https://','')
          }
          Write-Verbose "Parsed URI is $URI"
    }

    process {
        foreach ($U in $URI) {
            $port = $TCPPort
            write-verbose "$U`: Connecting on port $port"
            [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
            $req = [Net.HttpWebRequest]::Create("https://$U`:$port")
            write-verbose "Trying"
            $req.Timeout = $Timeoutms

            try {

                $req.GetResponse() | Out-Null
            }

            catch {
                if (!($req.ServicePoint.Certificate)) {
                    Write-Verbose "Couldn't connect to $U on port $port"
                    write-error "$U`: No Certificate returned."
                    break
                }
                else{
                    # Cert still received.

                }
            }

            if (!($req.ServicePoint.Certificate)) {
                write-error "No Certificate returned on $U"
            }

            $certinfo = $req.ServicePoint.Certificate
            Write-Verbose "$certinfo"

            $returnobj = [ordered]@{
                URI = $U;
                Port = $port;
                Subject = $certinfo.Subject;
                Thumbprint = $certinfo.GetCertHashString();
                Issuer = $certinfo.Issuer;
                SerialNumber = $certinfo.GetSerialNumberString();
                Issued = $certinfo.GetEffectiveDateString();
                Expires = $certinfo.GetExpirationDateString();
            } #end of returnobj

            $obj = new-object PSCustomObject -Property $returnobj

            return $obj
        } #end of foreach
    }#end of process{}

    end{}

} #end of function