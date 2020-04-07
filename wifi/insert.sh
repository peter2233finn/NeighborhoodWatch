. /etc/nwatch.conf

interface="$(ifconfig | grep mon | head -n 1 | awk '{print $1}' | tr ":" " "| xargs)"

channel_hop() {

        IEEE80211bg="1 2 3 4 5 6 7 8 9 10 11"
        IEEE80211bg_intl="$IEEE80211b 12 13 14"
        IEEE80211a="36 40 44 48 52 56 60 64 149 153 157 161"
        IEEE80211bga="$IEEE80211bg $IEEE80211a"
        IEEE80211bga_intl="$IEEE80211bg_intl $IEEE80211a"

        while true ; do
                for CHAN in $IEEE80211bg ; do
                        sudo iwconfig $interface channel $CHAN
                        sleep 1.5
                done
        done
}


function insert {
MAC="$3"
SSID="$4 $5 $6 $7 $8 $9"

dbInput="INSERT INTO SCANNERLIMBO(MAC, ESSID) VALUES('$MAC','$(echo $SSID|xargs)');"
mysql --user="$dbUser" --password="$dbPassword" --database="$dbName" --execute="$dbInput"

}
channel_hop &
echo $! >> /tmp/nwatch
#replace test with command and remove function test
sudo tcpdump -l -I -i "$interface" -e -s 256 type mgt subtype probe-req | awk -f /var/nwatch/wifi/parse-tcpdump.awk | while IFS= read -r output
do
        insert $output 
        echo "[INFO]: Found iprobe: $output" >> $logDir
done
