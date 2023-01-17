$attemptsAllowed = 5 # adjust this to make the script more or less persistent
$continueTrying = $true
$attemptsTried = 0 # for reporting
$successDetected = $false # a DO/WHILE condition

DO
{
  if ($attemptsTried -gt 0) { Start-Sleep -Seconds 5 } # delay on re-tries
  $attemptsTried++
  
  try
  {
    Write-Host "Attempting to do Task" -ForegroundColor Green
    
    # Insert Task you want to get done write here
    
    # Make an error here to see how it handles it (only for testing purposes)
    #Move-Item # this will cause an error if you uncomment this
    
    $successDetected = $true
    $continueTrying = $false
  }
  catch
  {
    Write-Host "Failed to do Task" -ForegroundColor Green
    
    Write-Host "attemptsAllowed = " $attemptsAllowed
    Write-Host "continueTrying = " $continueTrying
    Write-Host "attemptsTried = " $attemptsTried
    Write-Host "successDetected = " $successDetected
  }
  $attemptsAllowed--
} # end of Do loop
while (($continueTrying) -and ($attemptsAllowed -gt 0)) # Run until it either the Task is run successfully or until there are no Attempts left

# Ran out of Attempts and Task still didn't run successfully
if (($attemptsAllowed -eq 0) -and ($successDetected -eq $false)) { Write-Host "Task failed after " $attemptsTried " unsuccessful attempts." -ForegroundColor Yellow }

  Write-Host "attemptsAllowed = " $attemptsAllowed
  Write-Host "continueTrying = " $continueTrying
  Write-Host "attemptsTried = " $attemptsTried
  Write-Host "successDetected = " $successDetected
