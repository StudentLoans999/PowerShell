# This script allows user to input a new/updated password when ran, that will update the txt file which is a hash of the password, with a new hash 
$path = "\\ABC-app01\Public\Creds\ABCCredentials.txt"
read-host -assecurestring | convertfrom-securestring | out-file path
# EX: user inputs "password123" after running the script, well then in ABCCredentials.txt whatever the password was before, it is now a hash of password123
