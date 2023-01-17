$attemptsAllowed = 5 # adjust this to make the script more or less persistent
$continueTrying = $true
$attemptsTried = 0 # for reporting
$successDetected = $false # a DO/WHILE condition

DO
{
  if ($attemptsTried -gt 0) { Start-Sleep -Seconds 5 } # delay on re-tries
  $attemptsTried++
  
  try
