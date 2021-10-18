# RPCS3-ISOLauncher-Launchbox

New script build, can be run directly in Launchbox using PowerShell

Discussion. [RPCS3 ISO support](https://forums.launchbox-app.com/topic/42569-rpcs3-iso-support-with-powershell/)

## Install

1. Copy RPCS3-ISO-LaunchBox.ps1 script to same folder as the RPCS3.exe.
- IF NEEDED, change $RPCS3path variable inside ps1 script to direct path.

        $RPCS3path = "$PSScriptRoot\rpcs3.exe"  # this is default and loads rpcs3.exe from same folder as script, no change needed.

        $RPCS3path = "D:\Path\To\rpcs3.exe"     # change to path directly to script anywhere IF NEEDED.

2. Setup Launch box emulator like below screenshot.

![EmulatorConfig](https://github.com/ptmorris1/RPCS3-ISOLauncher-Launchbox/blob/master/screenshots/LaunchboxEmulatorConfig.png?raw=true)

- Emulator name can be whatever you want.

- Set application path to Powershell.exe.  I used Powershell 7 but WindowsPowershell shoud work as well.

## Powershell 7

    C:\Program Files\PowerShell\7\pwsh.exe

## WindowsPowershell

    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe

## Default Command-Line Parameters:

    -noprofile -executionpolicy bypass -WindowStyle hidden -file "E:\LaunchBox\Emulators\rpcs3\RPCS3-ISO-LaunchBox.ps1"

- Change path to where you put the RPCS3-ISO-LaunchBox.ps1 script.

3. Now to test by editing an ISO in Launchbox and change emulator to what you named your emulator, my example "RPCS3 ISO Launcher".

![ISO-Edit](https://github.com/ptmorris1/RPCS3-ISOLauncher-Launchbox/blob/master/screenshots/ISO-Edit.png?raw=true)

4. Launch game with Lanchbox and hope for the best.

# Troubleshooting

- If RPCS3 gives error about path, may need to change mount wait time.
Edit script and change line 12: Start-Sleep -Seconds 2
Change 2 to 3 or however many seconds your system needs to mount your ISO.

- If RPSS3 is slower to start on your system
Edit line 20 and change -Seconds to 3 or more as needed.