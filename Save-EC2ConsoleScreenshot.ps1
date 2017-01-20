<#
.Synopsis
   Saves the console screenshot of an Amazon EC2 instance. Requries an existing connection to AWS.
.DESCRIPTION
   This function retrieves the Amazon EC2 instance screenshot data, convert it back to bytes and saves it as jpeg. 
   By default, it won't overwrite the existing file but you can use the -overwrite switch to change the behaviour.
   The file path should end with .jpeg.
.EXAMPLE
   Saving the EC2 instance screenshot.

   PS C:\Windows\system32> Save-EC2ConsoleScreenshot -instance 'i-77777777777777777' -filepath 'c:\temp\screenshot.jpeg' -overwrite -Verbose
   VERBOSE: File already exists. Removing.
   VERBOSE: Image saved
#>
Function Save-EC2ConsoleScreenshot{

    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true,
            ValueFromPipeline = $true,
            Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$instance,
        
        [parameter(Mandatory=$true,
            Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$filepath,

        [switch]$overwrite
    )

    Begin{
        if (!(Get-AWSCredentials)){
            Write-Warning 'Not connected to AWS'
            break
        }
       
    }
    
    Process{
        try{
            $byte = [convert]::FromBase64String((Get-EC2ConsoleScreenshot -InstanceId $instance -ErrorAction Stop).ImageData)
        
            if (test-path -Path $filepath){
                if ($overwrite){
                    Write-Verbose -Message 'File already exists. Removing.'
                    del $filepath
                }
                else{
                    Write-Verbose -Message 'File already exists. Existing and no change was made. Consider using -overwrite.'
                    break
                }
            }
         
            [io.file]::WriteAllBytes($filepath,$byte)
            Write-Verbose -Message 'Image saved'
        }
        catch{
            Write-Warning 'Error gettting screenshot or saving file.'
        }
    }
        
    End{
    }
}
