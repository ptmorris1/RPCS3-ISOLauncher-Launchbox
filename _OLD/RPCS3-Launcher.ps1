# Needs rpcs3.exe path and ISO path as parameters.
param (    
    [string]$RPCS3path,
    [string]$ISOpath
)

# Mounts the ISO to a drive letter
$Vol = Mount-DiskImage -ImagePath $ISOpath -PassThru
# Then gets the drive letter that the ISO was mounted to.
$Vol = $vol | Get-Volume
# Created the $path variable to the EBOOT.BIN file for lanching in rpcs3
$path = $vol.DriveLetter + ":\PS3_GAME\USRDIR\EBOOT.BIN"

    # Lanches rpcs3 with EBOOT.BIN path
    & $RPCS3path $path
    
    # Waits for the rpcs3 process to end before script continues.
    Wait-Process rpcs3
    # Dismounts the ISO image drive
    Dismount-DiskImage -ImagePath $ISOpath
