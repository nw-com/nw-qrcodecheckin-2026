Param(
    [int]$Port = 8005
)

function Stop-ProcessOnPort([int]$P) {
    try {
        $conns = Get-NetTCPConnection -LocalPort $P -ErrorAction Stop
        $pids = $conns | Where-Object { $_.OwningProcess -and $_.OwningProcess -ne $PID } | Select-Object -ExpandProperty OwningProcess -Unique
        foreach ($pid in $pids) {
            Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        }
    } catch {
    }
}

Stop-ProcessOnPort -P $Port
for ($i = 0; $i -lt 25; $i++) {
    try {
        $listen = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
        if (-not $listen) { break }
    } catch {
        break
    }
    Start-Sleep -Milliseconds 200
}

$url = "http://localhost:$Port/index.html"
Write-Host "Serving $pwd at $url"
npx http-server ./ -p $Port -a 127.0.0.1 -c-1
