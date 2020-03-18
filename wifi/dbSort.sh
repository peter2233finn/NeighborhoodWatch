. /etc/nwatch.conf
set -f # disable globbing

while true
do
	declare -a array
	x=0
	while read line
	do 
		# makes sure its not the first row, which holds no relivand data
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
						macVendor=$(curl "http://macvendors.co/api/"$mac"/json"| jq '.result.company'|xargs)
						echo $macVendor
					fi
					((y++))
				done
				array+=("$line")

			fi
			essid=$((echo ${line[@]} | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
			time=$(echo $line | awk '{print $2 " " $3}')
			mac=$(echo $line | awk '{print $1}')
			mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into BEACON(MAC,ESSID,TIME) VALUES('$mac','$essid','$time');"
		fi

		mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into SCANNER(VENDOR,MAC,ESSID,TRILAT,TRILONG,LASTSEEN,TIME) VALUES('$macVendor','$mac','$query','$lat','$long','$last','$time');"
		mysql -u $dbUser -p"$dbPassword" nwatch -e"delete from SCANNERLIMBO where ESSID='$( echo ${query[@]} | xargs | tr '+' ' ' )'"
		((x++))

	done < <(mysql -u $dbUser -p"$dbPassword" nwatch -e"select MAC, TIME, ESSID from SCANNERLIMBO")
	sleep $wiggleFrequency
done
