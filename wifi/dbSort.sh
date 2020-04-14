. /etc/nwatch.conf
set -f # disable globbing

# videoDel delets videos that are removed from database by admin
videoDel=0

# Start infinite loop
while true
do
	wiggleStatus=1
	declare -a array
	x=0
	while read line
	do 
		# This checks if wiggle bans user. This can happen from too manyqueries today
		set=1
		if [[ $(cat /tmp/nwatch.process | grep limitReached|head -n 1) == "limitReached" ]]
		then
			echo "[Info]: Wigle limit still in effect. Will try again in 30 minuits." >> $logDir
			sleep 30m
			echo "" > /tmp/nwatch.process
			
			# makes sure its not the first row, which holds no relivant data
		elif (( $x != 0 ))
		then
			# query holds the SSID
			query=$((echo ${line[@]} | awk '{print $5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
			check=0
			# this checks if it is already in the database
			checker=$(mysql -u $dbUser -p"$dbPassword" nwatch -e"select ESSID from SCANNER where ESSID = '"$query"'")
			# if the checker is "" it is already in the database.
			if [[ $checker != "" ]]
			then
					set=0
				echo "[INFO]: $query is already in database. No need to query wiggle" >> $logDir
			else
				echo "[INFO]: $query is not in Database. Attempting to query wiggle" >> $logDir
				results=$(curl -s -H 'Accept:application/json' -u $wiggleAPI --basic "https://api.wigle.net/api/v2/network/search?ssid=$query")
				if [[ $(echo $results | jq ".success") == "false" ]]
				then
					set=0
					echo "[Info]: Wiggle failed to do query, because: $(echo "$results" | jq ".message")" >> $logDir
					if [[ $(echo "$results" | jq ".message") == *"too many queries today"* ]]
					then
						echo "limitReached" >> /tmp/nwatch.process
					fi	
					break
				fi
				declare -a tmp
				declare -a wiggleData
				y=0
				mac=$(echo ${line[@]} | awk '{print $2}')
				# runs through every results recieved from wiggle
				# This is all the data recieved from wigle in Json format
				while [[ $(echo $results | jq ".results[$y].trilat")  != "null" ]]
				do
					echo $results | jq ".results[$y].encryption"
					lat=$(echo $results | jq ".results[$y].trilat")
					long=$(echo $results | jq ".results[$y].trilong")
					last=$(echo $results | jq ".results[$y].lastupdt")
					time=$(echo ${line[@]} | awk '{print $3" "$4}')
					address=$(echo $(echo $results | jq ".results[$y].housenumber"" "|xargs)", " | grep -v "null, ")
					address+=$(echo $(echo $results | jq ".results[$y].road"" "|xargs)", " | grep -v "null, ")
					address+=$(echo $(echo $results | jq ".results[$y].city"" "|xargs)", " | grep -v "null, ")
					address+=$(echo $(echo $results | jq ".results[$y].country"|xargs)"." | grep -v "null, ")
					syntaxAdd=$(echo $address | tr "'" "\"")
					if (( $set == 1 ))
					then
						mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into SCANNER(ADDRESS,MAC,ESSID,TRILAT,TRILONG,LASTSEEN,TIME) VALUES('$syntaxAdd','$mac','$query','$lat','$long','$last','$time');"
					fi

					((y++))
				done
				array+=("$line")

			fi
			# This formats the data for the database
			essid=$((echo ${line[@]} | awk '{print $5" "$6" "$7" "$8" "$9" "$10}') | xargs | tr ' ' '+')
			time=$(echo $line | awk '{print $3 " " $4}')
			mac=$(echo $line | awk '{print $2}')
			# find mac vendor using oui.txt
			# It checks for buth versions of MAC oui data
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
			bList=$(mysql -u root -p"$dbPassword" nwatch -e "select WLIST from LISTS where WLIST = '"$essid"' LIMIT 1" | grep -i "$essid")
			ALERT=$(mysql -u root -p"$dbPassword" nwatch -e "select BLIST from LISTS where BLIST = '"$essid"' LIMIT 1" | grep -i "$essid")
			if [[ "$bList" == "" ]]
			then
				mysql -u $dbUser -p"$dbPassword" nwatch -e"insert into BEACON(VENDOR,MAC,ESSID,TIME) VALUES('$macVendor','$mac','$(echo $essid| sed "s/'/''/g")','$time');"
			else
				# This is triggered if the ESSID is blacklisted
				if [[ "$ALERT" != "" ]]
				then
					sh /var/nwatch/blacklistAlert.sh "$essid" "$mac" "$macVendor" "$time"
				fi
				echo "[Info]: The ESSID: $essid is whitelisted by a user." >> $logDir
			fi
			mysql -u $dbUser -p"$dbPassword" nwatch -e"delete from SCANNERLIMBO where ID='$(echo $line | awk '{print $1}')';"
	fi
	((x++))
	done < <(mysql -u $dbUser -p"$dbPassword" nwatch -e"select ID, MAC, TIME, ESSID from SCANNERLIMBO")

	# Every 5 loops, delete the videos not in the database
	dodel=$(($videoDel % 5))
		if (( $dodel == 0))
		then
			touch /tmp/nwatch-notDelete
			touch /tmp/nwatch-possDelete
			ls /srv/http/camEvents/ > /tmp/nwatch-possDelete
			while read camDatabase
			do
			        echo "$(echo $camDatabase | rev | tr "/" " "|awk '{print $1" "$2}'|rev)" >> /tmp/nwatch-notDelete
			done < <(mysql -u $dbUser -p"$dbPassword" nwatch -e"select VIDDIR from CAMEVENT;")

			while read delete; 
			do
				rm "/srv/http/camEvents/$(echo $delete |egrep -v "camEvents|VIDDIR";)" 2>&1 >/dev/null | grep -v "Is a directory"	
			done<<<$(diff --changed-group-format='%<%>' --unchanged-group-format='' /tmp/nwatch-notDelete /tmp/nwatch-possDelete)
			rm /tmp/nwatch-notDelete
			rm /tmp/nwatch-possDelete
		fi
	((videoDel++))
	sleep $wiggleFrequency
done
