# Needs rpcs3.exe path and ISO path as parameters.
param (
    [Parameter(Mandatory=$true)]
    [string]$RPCS3path,

    [Parameter(Mandatory=$true)]
    [string]$ISOpath,
    [Int32]$Seconds = '10'
)

# Mounts the ISO to a drive letter
$Vol = Mount-DiskImage -ImagePath $ISOpath -PassThru
# Then gets the drive letter that the ISO was mounted to.
$Vol = $vol | Get-Volume
# Created the $path variable to the EBOOT.BIN file for lanching in rpcs3
$path = $vol.DriveLetter + ":\PS3_GAME\USRDIR\EBOOT.BIN"
# Lanches rpcs3 with EBOOT.BIN path
& $RPCS3path $path
# sleeps until process has a chance to start
Start-Sleep -Seconds $Seconds
# Gets the rpcs3 process details
$Process = Get-Process rpcs3
    
    # Waits for the rpcs3 process to end before script continues.
    # Using While since script now keep rpcs3 process open even after GUI is closed
    While ($Process.MainWindowHandle -ne 0) {
        #checks ever second if process mainwindowhandle is 0
        Start-Sleep -Seconds 1
        $Process = Get-Process rpcs3
        }

    # Kills rpcs3 left open by script
    $Process | Stop-Process
    # Dismounts the ISO image drive
    Dismount-DiskImage -ImagePath $ISOpath