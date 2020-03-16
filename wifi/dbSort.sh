. /etc/nwatch.conf
set -f        # disable globbing

while true
do
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
	sleep $wiggleFrequency
done
