function Set-MonitorInputSource {
    <#
        .SYNOPSIS
        Helper function to set the monitor state.

        .EXAMPLE Switch to HDMI
        Set-MonitorInputSource -InputSource HDMI

        .EXAMPLE Switch to DisplayPort
        Set-MonitorInputSource -InputSource DisplayPort

        .NOTES
        # https://www.nirsoft.net/utils/control_my_monitor.html
        # https://johnstonsoftwaresolutions.com/2019/02/09/tip-switch-monitor-inputs-with-command-line/
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('HDMI', 'DisplayPort')]
        [string]$InputSource
    )
    $ExePath = 'C:\Users\user\AppData\Local\Nirsoft\ControlMyMonitor.exe'
    if (Test-Path $ExePath) {
        $InputSourceHash = @{
            'DisplayPort' = 15
            'HDMI'        = 17
        }
        $argList = @(
            '/SetValueIfNeeded'
            '\\.\DISPLAY1\Monitor0'
            '60'
            $InputSourceHash[$InputSource]
        )

        Start-Process -FilePath $ExePath -ArgumentList $argList -Wait
    } else {
        Write-Warning "Unable to locate ControlMyMoniror.exe at: [$ExePath]"
    }
}
