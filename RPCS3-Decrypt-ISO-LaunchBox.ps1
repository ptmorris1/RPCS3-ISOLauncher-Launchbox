# Will get ISO param from Launchbox or launch script in Powershell with   -ISOpath 'C:\myiso\game.iso'
param (
    [Parameter(Mandatory = $true)]
    [string]$ISOpath
)

##############  Stuff to change if required.
# Put script in same folder as rpcs3.exe or change to direct path.
$RPCS3path = "$PSScriptRoot\rpcs3.exe"
#Path to PS3DEC.exe
$PS3DEC = "$PSScriptRoot\ps3dec\PS3Dec.exe"
#path to disc key files for decryptions
$KeysPath = "$PSScriptRoot\dkeys"
#leave as '' to save to same location as ISO, or change to custom location between ''
$DecryptPath = ''
#Keep decrypted iso or delete after rpcs3 closes.  Default is 'yes' and will delete.
$DeleteFile = 'yes'

################# Start script
$Keys = Get-ChildItem -LiteralPath $KeysPath
$ISOname = [System.IO.Path]::GetFileNameWithoutExtension($ISOpath)
$Key = $Keys | Where-Object -Property name -Like "$ISOname.dkey"
$KeyValue = Get-Content -LiteralPath $key.FullName
if ([string]::IsNullOrWhiteSpace($DecryptPath)) {
    $DecryptISO = (Split-Path $ISOpath -Parent) + "\$ISOname" + '_DEC.iso'
} else {
    if ($DecryptPath -match '.+[^\\]\\$' ) {
        $DecryptISO = $DecryptPath + "$ISOname" + '_DEC.iso'
    } else {
        $DecryptISO = $DecryptPath + "\$ISOname" + '_DEC.iso'
    }
}

# Checks if decrypted ISO exists alerady and only decrypts if not present.
if (-not (Test-Path -LiteralPath $DecryptISO)){ & $PS3DEC d key $KeyValue $ISOpath $DecryptISO | Out-Null }

# Mounts the ISO to a drive letter
$Vol = Mount-DiskImage -ImagePath $DecryptISO -PassThru
# sleeps 2 seconds to wait for disk to mount.  Can be changed as needed.
Start-Sleep -Seconds 2
# Then gets the drive letter that the ISO was mounted to.
$Voldisk = $vol | Get-Volume
# Created the $path variable to the EBOOT.BIN file for lanching in rpcs3
$path = $Voldisk.DriveLetter + ':\PS3_GAME\USRDIR\EBOOT.BIN'
# Lanches rpcs3 with EBOOT.BIN path, ######can add extra arguments for rpcs3.exe if needed.  Not fully in this script.
& $RPCS3path $path
# sleeps 2 seconds until rpcs3 has a chance to start
Start-Sleep -Seconds 2
# Waits for rpcs3 to be closed
Wait-Process rpcs3
# Dismounts the ISO image drive
Dismount-DiskImage -ImagePath $DecryptISO
if ($DeleteFile -match 'yes') {Remove-Item -LiteralPath $DecryptISO -Force}