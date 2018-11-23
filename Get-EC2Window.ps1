function Get-EC2Windows {
  [CmdletBinding()]

  Param()

  Begin {
    Write-Verbose 'Getting instances'
    try {
      $instances = Get-ec2instance -Filter @(@{name = 'platform'; value = 'windows'}) -ErrorAction Stop
    }
    catch {
      Write-Warning 'Can not retrieve EC2 instance information.'
      throw
    }

    Write-Verbose "Total instance received: $(($instances).count)"
  }
  Process {
    foreach ($i in $instances) {
      try {
        $Name = ($i.instances.Tags.GetEnumerator() | Where-Object {$_.Key -eq 'Name'}).Value
      }
      catch {
        $Name = ''
      }
      try {
        $StackName = ($i.instances.Tags.GetEnumerator() | Where-Object {$_.Key -eq 'aws:cloudformation:stack-name'}).Value
      }
      catch {
        $StackName = ''
      }
      try {
        $IP = $i.instances.PrivateIpAddress
      }
      catch {
        $IP = ''
      }
      try {
        $KeyName = $i.instances.keyname
      }
      catch {
        $KeyName = ''
      }

      $prop = @{
        Name      = $Name
        StackName = $StackName
        IP        = $IP
        KeyName   = $KeyName
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }

  }
  End {}
}