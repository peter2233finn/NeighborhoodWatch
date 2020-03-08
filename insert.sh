clear
dbPass="3342234Pp&^"
dbUser='watch'
dbName="nwatch"

function test {
echo '00:00:19 -89dBm 00:0a:e2:1f:28:ab "BabyBooBear"'
}


function insert {
MAC="$3"
SSID="$4 $5 $6 $7 $8 $9"

dbInput="INSERT INTO SCANNERLIMBO(MAC, ESSID) VALUES('$MAC','$(echo $SSID|xargs)');"
mysql --user="$dbUser" --password="$dbPass" --database="$dbName" --execute="$dbInput"

}

#replace test with command and remove function test
test | while IFS= read -r output
do
	insert $output 
done

