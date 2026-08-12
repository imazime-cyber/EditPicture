param(
    [string]$Folder = (Get-Location).Path
)

Add-Type -AssemblyName System.Drawing

Write-Host ("Target folder: " + $Folder)
Write-Host "-----------------------------------"

$files = Get-ChildItem -LiteralPath $Folder -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|tif|tiff|bmp)$' }

$count = 0

foreach ($file in $files) {

    $dt = $null
    $img = $null

    try {
        $img = [System.Drawing.Image]::FromFile($file.FullName)
        $propItem = $img.GetPropertyItem(36867)
        $dtStr = [System.Text.Encoding]::ASCII.GetString($propItem.Value).Trim([char]0)
        $dt = [datetime]::ParseExact($dtStr, 'yyyy:MM:dd HH:mm:ss', $null)
    }
    catch {
        $dt = $null
    }
    finally {
        if ($img) { $img.Dispose() }
    }

    if (-not $dt) {
        $dt = $file.LastWriteTime
    }

    $base = $dt.ToString('yyyyMMdd_HHmmss')
    $newName = $base + $file.Extension
    $i = 1
    while (Test-Path -LiteralPath (Join-Path $Folder $newName)) {
        $newName = $base + '_' + $i + $file.Extension
        $i++
    }

    if ($newName -ne $file.Name) {
        Rename-Item -LiteralPath $file.FullName -NewName $newName
        Write-Host ($file.Name + "  ->  " + $newName)
        $count++
    }
}

Write-Host "-----------------------------------"
Write-Host ("Done. " + $count + " file(s) renamed.")
