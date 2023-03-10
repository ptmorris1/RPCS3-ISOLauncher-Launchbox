#path to ps3dec.exe
$PS3DEC = 'G:\path\ps3dec.exe'

#root folder where you keep encrypted iso
$ISOroot = 'G:\iso'

#root folder where decrypted ISO will be stored.
$ISOdecrypt = 'G:\decrypted'

#root folder you keep all dkeys files
$dKeys = 'G:\dkeys'

$ISOall = Get-ChildItem -LiteralPath $ISOroot
$report = foreach ($iso in $ISOall) {
    [int]$currentItem = [array]::indexof($ISOall, $iso)
    Write-Progress -Activity 'Decrypting isos....' -Status "Currently Decrypting - $($iso.name) - $($currentItem) of $($ISOall.Count - 1) $([math]::round((($currentItem + 1)/$ISOall.Count),2) * 100)% " -PercentComplete $([float](($currentItem + 1) / $ISOall.Count) * 100)
    Clear-Variable key -ErrorAction SilentlyContinue
    $Key = Get-ChildItem -LiteralPath $dKeys | Where-Object -Property name -Like "$([System.IO.Path]::GetFileNameWithoutExtension($iso.fullname)).dkey"
    if ($null -ne $key){
        Write-Host "Decrypting... $($iso.name)" -ForegroundColor Green
        $KeyValue = Get-Content -LiteralPath $key.FullName
        $DecryptISO = $ISOdecrypt + "\$([System.IO.Path]::GetFileNameWithoutExtension($iso.fullname))" + '_DEC.iso'
        & $PS3DEC d key $KeyValue $($iso.fullname) $DecryptISO
        [PSCustomObject]@{
            OrginalISO = $iso.name
            Decrypted = $DecryptISO
            Status = 'Completed'
        }
    } else {
        Write-Host "No key found for $($iso.name)" -ForegroundColor Red
        [PSCustomObject]@{
            OrginalISO = $iso.name
            Decrypted  = ''
            Status     = 'No Key found'
        }
    }
}

$report