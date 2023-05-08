$morningMinTime = Get-Date -Format 'HH:mm' '03:00'
$morningMinTime
$morningMaxTime = Get-Date -Format 'HH:mm' '15:00'
$morningMaxTime

$nightMinTime = Get-Date -Format 'HH:mm' '20:00'
$nightMinTime
$nightMaxTime = Get-Date -Format 'HH:mm' '22:00'
$nightMaxTime

$testTime = Get-Date -Format 'HH:mm' '02:00'
$testTime

$currentTime = Get-Date -Format 'HH:mm'
$currentTime

# If the script is run between 3am and 3pm, then do this
if (($currentTime -ge $morningMinTime) -and ($currentTime -le $morningMaxTime)) { Write-Host "am" }

# If the script is run between 8pm and 10pm, then do this
elseif (($currentTime -ge $nightMinTime) -and ($currentTime -le $nightMaxTime)) { Write-Host "pm" }
# If the script is run between 10:01pm and 2:59am or 3:01pm and 7:59pm, then do this
else { Write-Host "not in schedule" } 
