# RPCS3-ISOLauncher-Launchbox
Used to mount ISO images in Lanchbox then run with RPCS3 emulator
https://forums.launchbox-app.com/topic/42569-rpcs3-iso-support-with-powershell/

Run from PowerShell without Launchbox

RPCS3-ISO-Launcher.exe -RPCS3path "Path to rpcs3.exe" -ISOpath "path to PS3 ISO file"

.ps1 file is code, just used PS2EXE module to create .exe file

v2 released, wait-process not working anymore since script keeps rpcs3 process open even after closing all visable windows.  
Used new method to dismount image after rpce3 process main title windows is null.
Also uses -Seconds paramater to change default value for waiting for RPCS3 to fully load on your system.  Default 10 seconds but can be set to any value.