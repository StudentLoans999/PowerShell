# Creating a function since this is called upon often 
function DR-Get-DaysToX
{ # returns a negative number that when added to the current date, it gives you the last X's (day of the week) date. In this case it is looking for Saturday
  $daysToSaturday = 0 # change the name to whatever day of the week you want to get the date for. EX: $daysToMonday
  $today = (Get-Date).DayOfWeek
  
  if ($today -eq "Sunday") { $daysToSaturday = -1 } # if $daysToSaturday is something else, like $daysToMonday, then set $daysToMonday to equal -6
  if ($today -eq "Monday") { $daysToSaturday = -2 } # if $daysToSaturday is $daysToMonday, then set $daysToMonday to equal -7
  if ($today -eq "Tuesday") { $daysToSaturday = -3 } # if $daysToSaturday is $daysToMonday, then set $daysToMonday to equal -1
  if ($today -eq "Wednesday") { $daysToSaturday = -4 } # if $daysToSaturday is $daysToMonday, then set $daysToMonday to equal -2
  if ($today -eq "Thursday") { $daysToSaturday = -5 } # if $daysToSaturday is $daysToMonday, then set $daysToMonday to equal -3
  if ($today -eq "Friday") { $daysToSaturday = -6 } # if $daysToSaturday is $daysToMonday, then set $daysToMonday to equal -4
  if ($today -eq "Saturday") { $daysToSaturday = -7 } # if $daysToSaturday is $daysToMonday, then set $daysToMonday to equal -5
  
  return $daysToSaturday # EX: $daysToMonday
}
