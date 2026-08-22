function Join-LargeFile {
    param($OutputPath, $PartPrefix)
    $parts = Get-ChildItem -Path "$PartPrefix.part*" | Sort-Object {
        [int]($_.Name -replace '.*\.part(\d+)$', '$1')
    }
    $writer = [System.IO.File]::OpenWrite($OutputPath)
    try {
        foreach ($part in $parts) {
            $bytes = [System.IO.File]::ReadAllBytes($part.FullName)
            $writer.Write($bytes, 0, $bytes.Length)
            Write-Host "Appended $($part.Name)"
        }
    } finally {
        $writer.Close()
    }
}

Join-LargeFile -OutputPath ".\model.safetensors" -PartPrefix ".\model.safetensors"