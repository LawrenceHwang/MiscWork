$TraceStoreFolder = "c:\temp\$env:COMPUTERNAME"
$TraceFile = "trace-$(get-date -UFormat %Y-%m-%d-%H%M).etl"
$bucketname = "zzzzzzxxxxxxxxxxx/Tools/tracing/$env:COMPUTERNAME"

if (!(Test-Path -Path $TraceStoreFolder\ -PathType Container)){
    New-Item $TraceStoreFolder -ItemType Directory -Force
}

$p1 = Start-Process -FilePath netsh -ArgumentList "trace start capture=yes tracefile=$TraceStoreFolder\$TraceFile" -Wait -PassThru
Write-Output "Tracing started with exit code $($p1.exitcode)"

Read-Host -Prompt 'Press any key to stop tracing'

$p2 = Start-Process -FilePath netsh -ArgumentList 'trace stop' -Wait -PassThru
Write-Output "Tracing stopped with exit code $($p2.exitcode)"

Start-Sleep 5

Compress-Archive -Path $TraceStoreFolder -DestinationPath "$TraceStoreFolder\$(($TraceFile).Replace('.etl','.zip'))" -Verbose


break

Import-Module awspowershell

Initialize-AWSDefaults

Write-S3Object -BucketName $bucketname -File "$TraceStoreFolder\$(($TraceFile).Replace('.etl','.zip'))"