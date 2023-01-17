$folderPath = "\\ABC-app01\Public\Data\Files"
$fileFilter = "*ABC*.csv*
$filesLookingFor = (Get-ChildItem -Path $folderPath -Filter fileFilter) # could also type "gci" instead of "Get-ChildItem"

$OFS = "`r`n`r`n" # this will add a line betweeen each Write-Host result for clear formatting

$latestFile = $filesLookingFor | Sort-Object LastWriteTime -Descending | Select-Object -Index 0
$lastModTime = $latestFile.LastWriteTime

Write-Host `n "Here is the list of files found, ordered with the most Recent at the bottom:"`n -BackgroundColor Black
Write-Host $filesLookingFor`n -ForegroundColor Green
Write-Host "Here is the most Recent file:"`n
Write-Host $latestFile "Last Write TimeL $lastModTime" `n -ForegroundColor Yellow
