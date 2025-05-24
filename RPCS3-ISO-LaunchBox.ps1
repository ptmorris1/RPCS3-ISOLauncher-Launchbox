# Will get ISO param from Launchbox
param (
    [Parameter(Mandatory=$true)]
    [string]$ISOpath
)

# Put script in same folder as rpcs3.exe or change to direct path.
$RPCS3path = "$PSScriptRoot\rpcs3.exe"

function Write-Log {
    param(
        [string]$Message
    )
    $logPath = Join-Path $PSScriptRoot 'pwsh.log'
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp`t$Message" | Out-File -FilePath $logPath -Append -Encoding UTF8
}

try {
    Write-Log "INFO: Mounting ISO: $ISOpath"
    # Mounts the ISO to a drive letter
    $Vol = Mount-DiskImage -ImagePath $ISOpath -PassThru
    # Wait for the drive to be ready (up to 10 seconds)
    $mounted = $false
    for ($i = 0; $i -lt 10; $i++) {
        $Voldisk = $Vol | Get-Volume -ErrorAction SilentlyContinue
        if ($Voldisk -and $Voldisk.DriveLetter) {
            $mounted = $true
            break
        }
        Start-Sleep -Seconds 1
    }
    if (-not $mounted) {
        Write-Log "ERROR: Failed to mount ISO or get drive letter."
        throw "Failed to mount ISO or get drive letter."
    }
    # Created the $path variable to the EBOOT.BIN file for launching in rpcs3
    $path = $Voldisk.DriveLetter + ":\PS3_GAME\USRDIR\EBOOT.BIN"
    if (!(Test-Path $path)) {
        Write-Log "ERROR: EBOOT.BIN not found at $path"
        throw "EBOOT.BIN not found at $path"
    }
    Write-Log "INFO: Launching RPCS3 with $path"
    # Launches rpcs3 with EBOOT.BIN path, can add extra arguments for rpcs3.exe if needed. Not tested in this script.
    & $RPCS3path $path --no-gui --fullscreen
    Write-Log "INFO: Waiting for RPCS3 process to exit."
    # Waits for rpcs3 to be closed
    Wait-Process rpcs3
    Write-Log "INFO: RPCS3 process exited."
} catch {
    Write-Log "ERROR: $_"
    Write-Error $_
} finally {
    # Dismounts the ISO image drive
    if ($Vol) {
        Write-Log "INFO: Dismounting ISO: $ISOpath"
        Dismount-DiskImage -ImagePath $ISOpath -ErrorAction SilentlyContinue
    }
}