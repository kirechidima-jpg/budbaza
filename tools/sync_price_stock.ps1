# Sync БУДБАЗА js/data.js price/stock from "2 колонки" Прайс + Остатки .xls files.
# Usage: powershell -File tools\sync_price_stock.ps1 -PriceXls "C:\...\Прайс....xls" -StockXls "C:\...\Остатки....xls"
# Run via: $s = [System.IO.File]::ReadAllText("tools\sync_price_stock.ps1",[System.Text.Encoding]::UTF8); Invoke-Expression $s
# (do NOT run with `powershell -File` directly — Cyrillic args get mangled by codepage)

param(
    [Parameter(Mandatory=$true)][string]$PriceXls,
    [Parameter(Mandatory=$true)][string]$StockXls
)

$root = "C:\Users\Pc\Desktop\budbaza"
$dataFile = "$root\js\data.js"
$enc = New-Object System.Text.UTF8Encoding $False
$tmpPrice = "$root\tools\_price_tmp.txt"
$tmpStock = "$root\tools\_stock_tmp.txt"

function Convert-XlsToUnicodeTxt($xlsPath, $outPath) {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $wb = $excel.Workbooks.Open($xlsPath)
    if (Test-Path $outPath) { Remove-Item $outPath -Force }
    $wb.SaveAs($outPath, 42) # xlUnicodeText
    $wb.Close($false)
    $excel.Quit()
    [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($wb)
    [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
}

Write-Host "Converting xls files..."
Convert-XlsToUnicodeTxt $PriceXls $tmpPrice
Convert-XlsToUnicodeTxt $StockXls $tmpStock

# ── Parse Price file: 2-column layout, each block = Арт,Назва,Одиниця,Число1,Ціна ──
$priceMap = @{}   # Арт -> price string
$nameMap  = @{}   # Арт -> name (for new-product reporting)
$catMap   = @{}   # Арт -> original category label from file
$priceLines = Get-Content -Path $tmpPrice -Encoding Unicode
$catLeft = ""; $catRight = ""
foreach ($line in $priceLines) {
    $f = $line -split "`t"
    if ($f.Length -ge 5) {
        $art = $f[0].Trim(); $name = $f[1].Trim(); $price = ($f[4].Trim() -replace ',', '.')
        if ($art -eq "" -and $name -ne "") { $catLeft = $name }
        elseif ($art -ne "" -and $price -ne "") { $priceMap[$art] = $price; $nameMap[$art] = $name; $catMap[$art] = $catLeft }
    }
    if ($f.Length -ge 11) {
        $art = $f[6].Trim(); $name = $f[7].Trim(); $price = ($f[10].Trim() -replace ',', '.')
        if ($art -eq "" -and $name -ne "") { $catRight = $name }
        elseif ($art -ne "" -and $price -ne "") { $priceMap[$art] = $price; $nameMap[$art] = $name; $catMap[$art] = $catRight }
    }
}
Write-Host "Parsed prices: $($priceMap.Count)"

# ── Parse Stock file: 2-column layout, each block = Арт,Назва,Одиниця,Залишок ──
$stockMap = @{}
$stockLines = Get-Content -Path $tmpStock -Encoding Unicode
foreach ($line in $stockLines) {
    $f = $line -split "`t"
    if ($f.Length -ge 4) {
        $art = $f[0].Trim(); $name = $f[1].Trim(); $stock = ($f[3].Trim() -replace ',', '.')
        if ($art -ne "" -and $stock -ne "") { $stockMap[$art] = $stock; if (-not $nameMap.ContainsKey($art)) { $nameMap[$art] = $name } }
    }
    if ($f.Length -ge 9) {
        $art = $f[5].Trim(); $name = $f[7].Trim(); $stock = ($f[8].Trim() -replace ',', '.')
        if ($art -ne "" -and $stock -ne "") { $stockMap[$art] = $stock; if (-not $nameMap.ContainsKey($art)) { $nameMap[$art] = $name } }
    }
}
Write-Host "Parsed stocks: $($stockMap.Count)"

# ── Apply to data.js ──
$content = [System.IO.File]::ReadAllText($dataFile, $enc)
$lines = $content -split "`n"

$updated = 0; $zeroed = 0
$matchedArts = New-Object System.Collections.Generic.HashSet[string]
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if (-not ($line -match '^\s*\{id:\d+,')) { continue }
    if (-not ($line -match 'meta:"Арт\.: ([^"]+)"')) { continue }
    $art = $Matches[1]

    $hasPrice = $priceMap.ContainsKey($art)
    $hasStock = $stockMap.ContainsKey($art)

    if ($hasPrice -or $hasStock) {
        [void]$matchedArts.Add($art)
        if ($hasPrice) { $line = $line -replace 'price:[\d.]+', ('price:' + $priceMap[$art]) }
        if ($hasStock) { $line = $line -replace 'stock:[\d.]+', ('stock:' + $stockMap[$art]) }
        $lines[$i] = $line
        $updated++
    } else {
        $newLine = $line -replace 'stock:[\d.]+', 'stock:0'
        if ($newLine -ne $line) { $lines[$i] = $newLine; $zeroed++ }
    }
}
Write-Host "Updated: $updated, Zeroed (missing from files): $zeroed"

# ── Report Арт that are in files but NOT on site (for manual categorize+add) ──
$allArts = New-Object System.Collections.Generic.HashSet[string]
foreach ($k in $priceMap.Keys) { [void]$allArts.Add($k) }
foreach ($k in $stockMap.Keys) { [void]$allArts.Add($k) }
$newArts = $allArts | Where-Object { -not $matchedArts.Contains($_) }

Write-Host "`nArts in files but NOT found on site ($($newArts.Count)):"
foreach ($a in $newArts) {
    $p = if ($priceMap.ContainsKey($a)) { $priceMap[$a] } else { "?" }
    $s = if ($stockMap.ContainsKey($a)) { $stockMap[$a] } else { "0" }
    $n = if ($nameMap.ContainsKey($a)) { $nameMap[$a] } else { "?" }
    $c = if ($catMap.ContainsKey($a)) { $catMap[$a] } else { "?" }
    Write-Host "  $a | $n | Ціна:$p | Залишок:$s | Категорія(orig):$c"
}

$newContent = $lines -join "`n"
[System.IO.File]::WriteAllText($dataFile, $newContent, $enc)
Write-Host "`nSaved data.js. Now manually categorize the new arts above and add them (do NOT trust the orig category label), then run verification + commit."

Remove-Item $tmpPrice -Force -ErrorAction SilentlyContinue
Remove-Item $tmpStock -Force -ErrorAction SilentlyContinue
