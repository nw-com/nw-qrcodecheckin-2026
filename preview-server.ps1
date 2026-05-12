Param(
    [int]$Port = 8004
)

function Stop-ProcessOnPort([int]$P) {
    try {
        $conns = Get-NetTCPConnection -LocalPort $P -State Listen -ErrorAction Stop
        $pids = $conns | Select-Object -ExpandProperty OwningProcess -Unique
        foreach ($pid in $pids) {
            if ($pid -and $pid -ne $PID) {
                Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
            }
        }
    } catch {
    }
}

Stop-ProcessOnPort -P $Port

$url = "http://127.0.0.1:$Port/index.html"
Write-Host "Serving $pwd at $url"
npx http-server ./ -p $Port -a 127.0.0.1 -c-1
