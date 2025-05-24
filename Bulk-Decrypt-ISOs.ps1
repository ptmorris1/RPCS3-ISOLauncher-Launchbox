#path to ps3dec.exe
$PS3DEC = 'D:\Downloads\ps3dec.exe' # https://github.com/Redrrx/ps3dec/releases

#root folder where you keep encrypted iso
$ISOroot = 'G:\ps3\iso'

# Not implemented in this ps3dec yet.   Decrypts to same folder as iso file _decrypted.iso.  This script will move the file.
#root folder where decrypted ISO will be stored.
$ISOdecrypt = 'G:\ps3\iso\DECRYPTED'

#root folder you keep all .dkeys files
$dKeys = 'G:\ps3\iso\ps3_keys'

# Validate required paths and files
if (-not (Test-Path -LiteralPath $PS3DEC -PathType Leaf)) {
    Write-Host "ERROR: ps3dec.exe not found at path: $PS3DEC" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path -LiteralPath $ISOroot -PathType Container)) {
    Write-Host "ERROR: ISO root folder not found: $ISOroot" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path -LiteralPath $ISOdecrypt -PathType Container)) {
    Write-Host "ERROR: Decrypted ISO folder not found: $ISOdecrypt" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path -LiteralPath $dKeys -PathType Container)) {
    Write-Host "ERROR: dKeys folder not found: $dKeys" -ForegroundColor Red
    exit 1
}
$dkeyFiles = Get-ChildItem -LiteralPath $dKeys -Filter '*.dkey' -ErrorAction SilentlyContinue
if (-not $dkeyFiles) {
    Write-Host "ERROR: No .dkey files found in $dKeys" -ForegroundColor Red
    exit 1
}

## Begin Script do not change below this line.
$ISOall = Get-ChildItem -LiteralPath $ISOroot
$report = foreach ($iso in $ISOall) {
    # Write-Progress removed, ps3dec has its own output
    $Key = Get-ChildItem -LiteralPath $dKeys | Where-Object { $_.Name -like "$([System.IO.Path]::GetFileNameWithoutExtension($iso.FullName)).dkey" } | Select-Object -First 1
    if ($null -ne $Key) {
        Write-Host "Decrypting... $($iso.Name)" -ForegroundColor Green
        $KeyValue = Get-Content -LiteralPath $Key.FullName
        try {
            $output = & $PS3DEC --iso $iso.fullname --dk $KeyValue --skip
            # Parse ps3dec output for reporting
            $keyValid = $null
            $fileSize = $null
            $totalSectors = $null
            $totalRegions = $null
            $decryptTime = $null
            $outputFile = $null
            $errorMessage = $null
            foreach ($line in $output) {
                if ($line -match 'Key is valid') { $keyValid = $true }
                if ($line -match 'File size: ([\d.]+ MB), Total sectors: (\d+)') {
                    $fileSize = $matches[1]
                    $totalSectors = $matches[2]
                }
                if ($line -match 'Total regions detected: (\d+)') { $totalRegions = $matches[1] }
                if ($line -match 'Decryption completed in ([\d.]+) seconds') { $decryptTime = $matches[1] }
                if ($line -match 'Data written to (.+)') { $outputFile = $matches[1] }
                if ($line -match '^Error: (.+)$') { $errorMessage = $matches[1] }
            }
            if ($LASTEXITCODE -eq 0 -and -not $errorMessage) {
                # Move the decrypted file as-is to the target folder
                $decryptedSource = Join-Path -Path $iso.DirectoryName -ChildPath ("$($iso.Name)_decrypted.iso")
                $decryptedTarget = Join-Path -Path $ISOdecrypt -ChildPath ("$($iso.Name)_decrypted.iso")
                if (Test-Path -LiteralPath $decryptedSource) {
                    Move-Item -LiteralPath $decryptedSource -Destination $decryptedTarget -Force
                }
                [PSCustomObject]@{
                    OriginalISO = $iso.Name
                    Decrypted   = (Split-Path $decryptedTarget -Leaf)
                    Status      = 'Decrypted'
                    KeyValid    = $keyValid
                    FileSizeMB  = $fileSize
                    TotalSectors= $totalSectors
                    Regions     = $totalRegions
                    TimeSec     = $decryptTime
                    OutputFile  = $outputFile
                    ErrorMessage= $errorMessage
                }
            } else {
                Write-Host "Decryption failed for $($iso.Name)" -ForegroundColor Yellow
                [PSCustomObject]@{
                    OriginalISO = $iso.Name
                    Decrypted   = ''
                    Status      = 'Decryption Failed'
                    ErrorMessage= $errorMessage
                }
            }
        } catch {
            Write-Host "Error decrypting $($iso.Name): $_" -ForegroundColor Red
            [PSCustomObject]@{
                OriginalISO = $iso.Name
                Decrypted   = ''
                Status      = 'Error Occurred'
            }
        }
    } else {
        Write-Host "No key found for $($iso.Name)" -ForegroundColor Red
        [PSCustomObject]@{
            OriginalISO = $iso.Name
            Decrypted   = ''
            Status      = 'No Key found'
        }
    }
}

$report

# Cleanup: Remove any .log file matching the pattern YYYY-MM-DD_HH-MM-SS.log in the 'log' subfolder of the current working directory
$logFolder = Join-Path (Get-Location) 'log'
$logPattern = '*_??-??-??.log'
if (Test-Path $logFolder) {
    $logFiles = Get-ChildItem -Path $logFolder -Filter $logPattern -ErrorAction SilentlyContinue
    foreach ($log in $logFiles) {
        Remove-Item -LiteralPath $log.FullName -Force -ErrorAction SilentlyContinue
    }
}