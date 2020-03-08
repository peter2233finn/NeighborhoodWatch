. /etc/nwatch.conf
set -f        # disable globbing
declare -a array
x=0
while read line
do 
	if (( $x != 0 ))
	then
	
	query=$((echo ${line[@]} | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
	results=$(curl -s -H 'Accept:application/json' -u $wiggleAPI --basic "https://api.wigle.net/api/v2/network/search?ssid=$query")
	#python -m json.tool
	echo $query

#echo '{"success":true,"totalResults":4,"first":1,"last":4,"resultCount":4,"results":[{"trilat":43.67179489000000103260390460491180419921875,"trilong":-79.379852290000002312808646820485591888427734375,"ssid":"Babyboobear","qos":2,"transid":"20160620-00000","firsttime":"2016-06-09T20:00:00.000Z","lasttime":"2017-01-23T19:00:00.000Z","lastupdt":"2017-09-01T16:00:00.000Z","netid":"84:94:8C:36:51:48","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":false,"channel":4,"encryption":"wpa2","country":"CA","region":"Ontario","city":"Toronto","housenumber":"298","road":"Bloor Street East","postalcode":"M4W 3Y3"},{"trilat":53.41682433999999801699232193641364574432373046875,"trilong":-6.14678240000000020160086933174170553684234619140625,"ssid":"BabyBooBear","qos":5,"transid":"20180604-00000","firsttime":"2018-06-04T14:00:00.000Z","lasttime":"2019-10-24T17:00:00.000Z","lastupdt":"2019-10-24T17:00:00.000Z","netid":"8C:04:FF:B9:BE:12","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":true,"channel":1,"encryption":"wpa2","country":"IE","region":null,"city":null,"housenumber":null,"road":"Station Road","postalcode":"13"},{"trilat":42.039039610000003222012310288846492767333984375,"trilong":-91.5630111699999957863838062621653079986572265625,"ssid":"BabyBooBear","qos":0,"transid":"20181208-00000","firsttime":"2018-12-08T16:00:00.000Z","lasttime":"2018-12-08T14:00:00.000Z","lastupdt":"2018-12-08T14:00:00.000Z","netid":"E4:F0:42:CA:74:0C","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":false,"channel":6,"encryption":"wpa2","country":"US","region":"IA","city":null,"housenumber":null,"road":"44th Street","postalcode":"52302"},{"trilat":53.4173660299999966127870720811188220977783203125,"trilong":-6.14791535999999982919916874379850924015045166015625,"ssid":"BabyBooBear","qos":5,"transid":"20180604-00000","firsttime":"2018-06-04T14:00:00.000Z","lasttime":"2020-02-19T23:00:00.000Z","lastupdt":"2020-02-19T23:00:00.000Z","netid":"E8:FC:AF:FE:1D:9B","name":null,"type":"infra","comment":null,"wep":"2","bcninterval":0,"freenet":"?","dhcp":"?","paynet":"?","userfound":true,"channel":6,"encryption":"wpa2","country":"IE","region":null,"city":null,"housenumber":null,"road":"Station Road","postalcode":"13"}],"search_after":256171982069147,"searchAfter":"256171982069147"}' | python -m json.tool

		declare -a tmp
		echo $tmp
		declare -a wiggleData
		y=0
		while [[ $(echo $results | jq ".results[$y].trilat")  != "null" ]]
		do

			if [[ $(echo $results | jq ".results[$y].encryption") != "\"unknown\"" ]]
			then
			echo $results | jq ".results[$y].encryption"
				echo $query
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

		echo XXX
		
		array+=("$line")
	fi
	((x++))
done < <(mysql -u $dbUser -p"$dbPassword" nwatch -e"select MAC, TIME, ESSID from SCANNERLIMBO")
#echo ${array[@]}


