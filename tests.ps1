Import-Module .\prometheus.psm1 -Force

1..50 | %{
    Write-Output -InputObject (Get-Date)
    $metric = Get-Counter | Select-Object -ExpandProperty 'CounterSamples' | ?{$PSItem.InstanceName -match '[a-zA-Z_:][a-zA-Z0-9_:]*'}
    $metric = $metric | ConvertTo-PromExposition
    $response = Invoke-WebRequest -Uri "http://localhost:9091/metrics/job/pushgateway/" -Method Post -Body $metric
    Start-Sleep -Seconds 2
}