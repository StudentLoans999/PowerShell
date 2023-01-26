param
(
    [string] $serverName = "localhost",
    [string] $userName = ""
)
# ^ Can do it this way to catch  the Parameters from somewhere else (usually a script)

Write-Host("Server: $serverName")

# Or could pass values to the Parameter and then catch them in a Function 
$userName = ""

writeFullName $name1 $name2
function writeFullName($str1, $str2) { Write-Output "Hello, $str1 $str2" }

$firstName = Read-Host "Enter your First Name"
$lastName = Read-Host "Enter your Last Name"
writeFullName $firstName $lastName

$userName = $firstName + $lastName
$userName
