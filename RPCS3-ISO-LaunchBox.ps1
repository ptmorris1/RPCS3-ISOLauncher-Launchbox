# Will get ISO param from Launchbox
param (
    [Parameter(Mandatory=$true)]
    [string]$ISOpath
)

# Need to set path to rpcs3.exe file
$RPCS3path = "E:\LaunchBox\Emulators\rpcs3\rpcs3.exe"
# Mounts the ISO to a drive letter
$Vol = Mount-DiskImage -ImagePath $ISOpath -PassThru
# sleeps to wait for disk to mount and obtain drive letter.
Start-Sleep -Seconds 2
# Then gets the drive letter that the ISO was mounted to.
$Voldisk = $vol | Get-Volume
# Created the $path variable to the EBOOT.BIN file for lanching in rpcs3
$path = $Voldisk.DriveLetter + ":\PS3_GAME\USRDIR\EBOOT.BIN"
# Lanches rpcs3 with EBOOT.BIN path, can add extra arguments for rpcs3.exe if needed.  Not tested.
& $RPCS3path $path
# sleeps until rpcs3 has a chance to start
Start-Sleep -Seconds 2
# Waits for rpcs3 to be closed
Wait-Process rpcs3
# Dismounts the ISO image drive
Dismount-DiskImage -ImagePath $ISOpath