. /etc/nwatch.conf
set -f # disable globbing


while true
do
	wiggleStatus=1
	declare -a array
	x=0
	while read line
	do 
		set=1
		if [[ $(cat /tmp/nwatch.process | grep limitReached|head -n 1) == "limitReached" ]]
		then
			echo "Wiggle limit still in effect. Will try again in 30 minuits." >> $logDir
			sleep 30
			
			# makes sure its not the first row, which holds no relivand data
		elif (( $x != 0 ))
		then
			# query holds the SSID
			query=$((echo ${line[@]} | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
			check=0
			# this checks if it is already in the database
			checker=$(mysql -u $dbUser -p"$dbPassword" nwatch -e"select ESSID from SCANNER where ESSID = '"$query"'")
			# if the checker is "" it is already in the database.
			if [[ $checker != "" ]]
			then
					set=0
				echo ALREADY IN DB NO NEED TO QUERY WIGGLE
			else
				echo NOT IN DB QUERYING WIGGLE
				results=$(curl -s -H 'Accept:application/json' -u $wiggleAPI --basic "https://api.wigle.net/api/v2/network/search?ssid=$query")

				if [[ $(echo $results | jq ".success") == "false" ]]
				then
					set=0
					echo "Wiggle failed to do query, because: $(echo "$results" | jq ".message")" >> $logDir
					if [[ $(echo "$results" | jq ".message") == *"too many queries today"* ]]
					then
						echo "limitReached" >> /tmp/nwatch.process
					fi	
					break
				fi
				declare -a tmp
				declare -a wiggleData
				y=0
				mac=$(echo ${line[@]} | awk '{print $1}')




				# runs through every results recieved from wiggle
				while [[ $(echo $results | jq ".results[$y].trilat")  != "null" ]]
				do
					echo $results | jq ".results[$y].encryption"
					lat=$(echo $results | jq ".results[$y].trilat")
					long=$(echo $results | jq ".results[$y].trilong")
					last=$(echo $results | jq ".results[$y].lastupdt")
					time=$(echo ${line[@]} | awk '{print $2" "$3}')

					address=$(echo $(echo $results | jq ".results[$y].housenumber"" "|xargs)", " | grep -v "null, ")
					address+=$(echo $(echo $results | jq ".results[$y].road"" "|xargs)", " | grep -v "null, ")
					address+=$(echo $(echo $results | jq ".results[$y].city"" "|xargs)", " | grep -v "null, ")
					address+=$(echo $(echo $results | jq ".results[$y].country"|xargs)", " | grep -v "null, ")
					syntaxAdd=$(echo $address | tr "'" "\"")
					if (( $set == 1 ))
					then
						mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into SCANNER(ADDRESS,MAC,ESSID,TRILAT,TRILONG,LASTSEEN,TIME) VALUES('$syntaxAdd','$mac','$query','$lat','$long','$last','$time');"
					fi

					((y++))
				done
				array+=("$line")

			fi
			essid=$((echo ${line[@]} | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
			time=$(echo $line | awk '{print $2 " " $3}')
			#echo $time
			mac=$(echo $line | awk '{print $1}')

			# find mac vendor using oui.txt
			macVendor=$(grep -i "$(echo $mac | cut -c 1-11 | sed "s/://g")" /etc/nwatch/oui.txt -m 1)
			if [[ $macVendor=="" ]]
			then
				macVendor=$(grep -i "$(echo $mac | cut -c 1-9 | sed "s/://g")" /etc/nwatch/oui.txt -m 1)
			fi
			if [[ $macVendor == "" ]]
			then
				macVendor="Unknown"
			else
				macVendor=$(echo $macVendor | awk '{print $4 $5 $6 $7 $8 $9}')
			fi
			# Adds stupid \r charecter for some reason. xargs wont remove
			macVendor=$(echo ${macVendor:-1} | tr -d '\r' | xargs echo -n | tr "'" "\"")

			# Backup way to find MAC address
			# macVendor="$(curl "http://macvendors.co/api/"$mac"/json"| jq '.result.company'|xargs)"

			mysql -u $dbUser -p"$dbPassword" nwatch -e "insert into BEACON(VENDOR,MAC,ESSID,TIME) VALUES('$macVendor','$mac','$essid','$time');"
			mysql -u $dbUser -p"$dbPassword" nwatch -e"delete from SCANNERLIMBO where ESSID='$( echo -n ${query[@]} | xargs | tr '+' ' ' )' and TIME = '$(echo -n "$time")';"

	fi
	((x++))
	done < <(mysql -u $dbUser -p"$dbPassword" nwatch -e"select MAC, TIME, ESSID from SCANNERLIMBO")
	sleep $wiggleFrequency
done
