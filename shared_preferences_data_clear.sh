echo "
# --------------------------------------------------
#
# shared preferences data clear 
#
# --------------------------------------------------
"
grepAppName="stackremote"
packageName=$(echo 'pm list package' | adb shell | grep $grepAppName)
appFullName=$(echo $packageName | sed -e 's/package://g')
echo "data clear target appFullName : $appFullName"

echo "pm clear $appFullName" | adb shell
