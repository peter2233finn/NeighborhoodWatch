. /etc/nwatch.conf
set -f        # disable globbing

while true
do
	declare -a array
	x=0
	while read line
	do 
		# makes sure its not the first row, which holds no relivand data
echo "X"$query"X"
echo xx
		if (( $x != 0 ))
		then
		# query holds the SSID
		query=$((echo ${line[@]} | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
		check=0

		# this checks if it is already in the database
		checker=$(mysql -u $dbUser -p"$dbPassword" nwatch -e"select MAC, TIME, ESSID from SCANNER where ESSID = '"$query"'")
			# if the checker is "" it is already in the database.
			if [[ $checker != "" ]]
			then
				echo ALREADY IN DB NO NEED TO QUERY WIGGLE
			else
				echo NOT IN DB
				results=$(curl -s -H 'Accept:application/json' -u $wiggleAPI --basic "https://api.wigle.net/api/v2/network/search?ssid=$query")
#results='{"success":true,"totalResults":4,"first":1,"last":4,"resultCount":4,"results":[{"trilat":43.67179489,"trilong":-79.37985229,"ssid":"Babyboobear","qos":2,"transid":"20160620-00000","firsttime":"2016-06-09T20:00:00.000Z","lasttime":"2017-01-23T19:00:00.000Z","lastupdt":"2017-09-01T16:00:00.000Z","netid":"84:94:8C:36:51:48","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":false,"channel":4,"encryption":"wpa2","country":"CA","region":"Ontario","city":"Toronto","housenumber":"298","road":"Bloor Street East","postalcode":"M4W 3Y3"},{"trilat":53.41682434,"trilong":-6.14678240,"ssid":"BabyBooBear","qos":5,"transid":"20180604-00000","firsttime":"2018-06-04T14:00:00.000Z","lasttime":"2019-10-24T17:00:00.000Z","lastupdt":"2019-10-24T17:00:00.000Z","netid":"8C:04:FF:B9:BE:12","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":true,"channel":1,"encryption":"wpa2","country":"IE","region":null,"city":null,"housenumber":null,"road":"Station Road","postalcode":"13"},{"trilat":42.03903961,"trilong":-91.56301117,"ssid":"BabyBooBear","qos":0,"transid":"20181208-00000","firsttime":"2018-12-08T16:00:00.000Z","lasttime":"2018-12-08T14:00:00.000Z","lastupdt":"2018-12-08T14:00:00.000Z","netid":"E4:F0:42:CA:74:0C","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":false,"channel":6,"encryption":"wpa2","country":"US","region":"IA","city":null,"housenumber":null,"road":"44th Street","postalcode":"52302"},{"trilat":53.41736603,"trilong":-6.14791536,"ssid":"BabyBooBear","qos":5,"transid":"20180604-00000","firsttime":"2018-06-04T14:00:00.000Z","lasttime":"2020-02-19T23:00:00.000Z","lastupdt":"2020-02-19T23:00:00.000Z","netid":"E8:FC:AF:FE:1D:9B","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":true,"channel":6,"encryption":"wpa2","country":"IE","region":null,"city":null,"housenumber":null,"road":"Station Road","postalcode":"13"}],"searchAfter":"256171982069147","search_after":256171982069147}'

		declare -a tmp
		declare -a wiggleData
		y=0
		# runs through every results recieved from wiggle
		while [[ $(echo $results | jq ".results[$y].trilat")  != "null" ]]
		do

			if [[ $(echo $results | jq ".results[$y].encryption") != "\"unknown\"" ]]
			then
			echo $results | jq ".results[$y].encryption"
				lat=$(echo $results | jq ".results[$y].trilat")
				long=$(echo $results | jq ".results[$y].trilong")
				mac=$(echo ${line[@]} | awk '{print $1}')
				last=$(echo $results | jq ".results[$y].lastupdt")
				time=$(echo ${line[@]} | awk '{print $2" "$3}')
				mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into SCANNER(MAC,ESSID,TRILAT,TRILONG,LASTSEEN,TIME) VALUES('$mac','$query','$lat','$long','$last','$time');"
				mysql -u $dbUser -p"$dbPassword" nwatch -e"delete from SCANNERLIMBO where ESSID='$(echo ${query[@]} | xargs | tr '+' ' ')'"
				fi
				((y++))
	
			done
			array+=("$line")

			fi

			#check=1
			essid=$((echo ${line[@]} | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
			time=$(echo $line | awk '{print $2 " " $3}')
			mac=$(echo $line | awk '{print $1}')
			mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into BEACON(MAC,ESSID,TIME) VALUES('$mac','$essid','$time');"


		fi
		((x++))
	done < <(mysql -u $dbUser -p"$dbPassword" nwatch -e"select MAC, TIME, ESSID from SCANNERLIMBO")
	sleep $wiggleFrequency
done
