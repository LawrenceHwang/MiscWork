function Get-ReversedString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [string]$String
    )

    $CharArray = $String.ToCharArray()

    #region PowerShell way
    <#
  $Result = @()

  for ($i = $CharArray.count-1; $i -ge 0 ; $i--){
    $Result = $Result + $CharArray[$i]
  }
  $Result -join ''
  #>
    #endregion PowerShell way

    #region .Net way
    [array]::Reverse($CharArray)
    -join $CharArray
    #endregion .Net way
}