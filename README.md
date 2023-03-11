# RPCS3-ISOLauncher-Launchbox

This is a PowerShell script to mount an ISO image to be run in the [RPCS3](https://rpcs3.net) emulator using [Launchbox](https://www.launchbox-app.com) and unmount when program closes.

Can also be used without Lanchbox. Follow step 1 below then run in powershell like: `.\RPCS3-ISO-LaunchBox.ps1 -ISOpath D:\my.iso`

Can be run directly in Launchbox using PowerShell

Discussion:  [RPCS3 ISO support](https://forums.launchbox-app.com/topic/42569-rpcs3-iso-support-with-powershell/)

</br>
</br>

## Install

1. Copy RPCS3-ISO-LaunchBox.ps1 script to same folder as the RPCS3.exe.
    * If you don't want to put script in same folder, change $RPCS3path variable to your rpcs3.exe file.
```powershell
$RPCS3path = "$PSScriptRoot\rpcs3.exe"  # this is default and loads rpcs3.exe from same folder as script, no change needed.
```
```powershell
$RPCS3path = "D:\Path\To\rpcs3.exe"     # change to path directly to script anywhere IF NEEDED.
```

2. Setup Launch box emulator like below screenshot.
   * Emulator name can be whatever you want.
   * Set application path to Powershell.exe.  I used Powershell 7 but WindowsPowershell shoud work as well.

![EmulatorConfig](https://github.com/ptmorris1/RPCS3-ISOLauncher-Launchbox/blob/master/screenshots/LaunchboxEmulatorConfig.png?raw=true)

## Powershell 7 application path

    C:\Program Files\PowerShell\7\pwsh.exe

## WindowsPowershell application path

    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe

## Default Command-Line Parameters:

    -noprofile -executionpolicy bypass -WindowStyle hidden -file "E:\LaunchBox\Emulators\rpcs3\RPCS3-ISO-LaunchBox.ps1"

- Change path to where you put the RPCS3-ISO-LaunchBox.ps1 script.

</br>

3. Now to test by editing an ISO in Launchbox and change emulator to what you named your emulator, my example "RPCS3 ISO Launcher".

![ISO-Edit](https://github.com/ptmorris1/RPCS3-ISOLauncher-Launchbox/blob/master/screenshots/ISO-Edit.png?raw=true)

4. Launch game with Lanchbox and hope for the best. :grin:

</br>
</br>

# RPCS3-Decrypt-ISO-LaunchBox

This is a PowerShell script to decrypt and mount an ISO image to be run in the [RPCS3](https://rpcs3.net) emulator using [Launchbox](https://www.launchbox-app.com) after closing it will unmount and delete decrypted iso.

Same installation setup as RPCS3-ISO-LaunchBox.ps1 but extra options needed and need to be changed in script.

Required:
- windows computer
- ps3dec.exe  tested using [PS3Dec_R5](https://github.com/al3xtjames/PS3Dec)
- dkeys for each game.
- encrypted PS3 ISO files.
- Powershell.

```powershell
$PS3DEC = "$PSScriptRoot\ps3dec\PS3Dec.exe"  ## must point to ps3.exe.  Default is in ps3dec folder with rpcs3.exe
```
```powershell
$KeysPath = "$PSScriptRoot\dkeys" ## Must point to folder with dkeys.  Default is in folder called dkeys with rpcs3.exe
```
```powershell
$DecryptPath = '' ## Must point to folder where decrypted ISO will be written.  Default is same folder as orginal ISO
```

Discussion:  [RPCS3-Decrypt-ISO-LaunchBox](https://forums.launchbox-app.com/topic/72105-ps3-looking-to-create-a-batch-file-to-decrypt-isos-with-ps3dec-when-launching-a-game-then-delete-the-decrypted-ps3-file-on-quit/)

</br>
</br>

# Bulk-Decrypt-ISOs

Simple script to bulk decrypt a folder full of encrypted ISOs.

Required:
- windows computer
- ps3dec.exe  tested using [PS3Dec_R5](https://github.com/al3xtjames/PS3Dec)
- dkeys for each game.
- encrypted PS3 ISO files.
- Powershell.  Must set [execution_policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.3) to remotesigned.
  ```powershell
  Set-ExecutionPolicy remotesigned -force
  ```

Instructions:
- Download script and edit with notepad or your favorite text\code editor.
- Change 1st 4 [variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-7.3) to paths that suit your needs.
  * $PS3DEC - Path to ps3dec.exe file. Example:  'C:\path\ps3dec.exe'
  * $ISOroot - Path to where you have your encrypted ISOs stored.  Name must match dkey file exactly excluding file extension.
  * $ISODecrypt - Path to folder where decrypted ISO files will be written.
  * $dkeys - Path to folder that include all dkeys for your ISO files.  Must be named same as ISO file excluding file extension.
- Open Powershell and set execution policy with command
  * Set-ExecutionPolicy remotesigned -force
  * May need to restart powershell afterwards if each ISO asks for a confirmation prompt.
- Enter path to the saved script and run.  
  * Need help? [ReadMe](https://learn.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/how-to-write-and-run-scripts-in-the-windows-powershell-ise?view=powershell-7.3)

# Troubleshooting ISO launcher

***E SYS: Booting ':/PS3_GAME/USRDIR/EBOOT.BIN' with cli argument failed: reason: Invalid file or folder***

- If RPCS3 gives error about path, may need to change mount wait time.
Edit script and change line 12: ***Start-Sleep -Seconds 2***
Change 2 to 3 or however many seconds your system needs to mount your ISO.

***RPCS3 closes to fast***

- If RPSS3 is slower to start on your system
Edit line 20 and change -Seconds to 3 or more as needed.

</br>
</br>

# Troubleshooting decrypt ISO launcher

</br>
</br>

# Troubleshooting bulk decrypt script

