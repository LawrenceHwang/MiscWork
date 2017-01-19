$finder = New-Object -ComObject UPnP.UPnPDeviceFinder
$urn = 'upnp:rootdevice'
$devices = $finder.FindByType($urn, 0)
$devices
foreach($device in $devices)
{
    Write-Host -ForegroundColor Red ---------------------------------------------
    Write-Host -ForegroundColor Green Device Name: $device.FriendlyName
    Write-Host -ForegroundColor Green Unique Device Name: $device.UniqueDeviceName
    Write-Host -ForegroundColor Green Description: $device.Description
    Write-Host -ForegroundColor Green Model Name: $device.ModelName
    Write-Host -ForegroundColor Green Model Number: $device.ModelNumber
    Write-Host -ForegroundColor Green Serial Number: $device.SerialNumber
    Write-Host -ForegroundColor Green Manufacturer Name: $device.ManufacturerName
    Write-Host -ForegroundColor Green Manufacturer URL: $device.ManufacturerURL
    Write-Host -ForegroundColor Green Type: $device.Type
}

Start-Service SSDPSRV
Stop-Service upnphost


Get-Service -Name SSDPSRV

Get-NetFirewallRule -DisplayName 'Network Discovery*SSDP*'

<#
IsRootDevice     : True
RootDevice       : System.__ComObject
ParentDevice     : 
HasChildren      : True
Children         : System.__ComObject
UniqueDeviceName : uuid:RINCON_949F3E173F8C01400
FriendlyName     : 10.0.1.23 - Sonos PLAY:1
Type             : urn:schemas-upnp-org:device:ZonePlayer:1
PresentationURL  : 
ManufacturerName : Sonos, Inc.
ManufacturerURL  : http://www.sonos.com/
ModelName        : Sonos PLAY:1
ModelNumber      : S12
Description      : Sonos PLAY:1
ModelURL         : http://www.sonos.com/products/zoneplayers/S12
UPC              : 
SerialNumber     : 
Services         : System.__ComObject

#>