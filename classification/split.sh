function Split-LargeFile {
    param($Path, $ChunkSizeMB = 1500)
    $chunkSize = $ChunkSizeMB * 1MB
    $buffer = New-Object byte[] $chunkSize
    $reader = [System.IO.File]::OpenRead($Path)
    $i = 0
    try {
        while (($bytesRead = $reader.Read($buffer, 0, $chunkSize)) -gt 0) {
            $partPath = "$Path.part$i"
            $writer = [System.IO.File]::OpenWrite($partPath)
            try {
                $writer.Write($buffer, 0, $bytesRead)
            } finally {
                $writer.Close()
            }
            Write-Host "Wrote $partPath ($bytesRead bytes)"
            $i++
        }
    } finally {
        $reader.Close()
    }
}

Split-LargeFile -Path ".\classification\model.safetensors" -ChunkSizeMB 1500