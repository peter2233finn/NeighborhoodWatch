. /etc/nwatch.conf
while true
do
	# Runs through each video file
	# Video file names are stored as sql time format
	for i in /var/nwatch/camera/*;
	do
		if [[ ${i: -3} == "mkv" ]]
		then
			# Checks if remote storage is set in
			# /etc/nwatch.conf
			if [[ $storage != "" ]]
				then
				if [[ ! -d "$storage/" ]]
				then
					# If the storage stated in config file doesnt exist
					# exit so watchdog will handle the error
					echo "[ERR]: The directory to store videos ($storage) has failed. Exiting. Watchdog will attempt again in 30 seconds"
					echo "[ERR]: The videos have not been deleted and are stored in /var/nwatch/camera"
					exit
				fi
			fi

			# Time is SQL date format in the video file name
			time=$(echo ${i:: -4} | tr "/" " " | rev | awk '{print $1 " " $2}'| rev)
			fileName=$(echo $i | tr "/" " " | rev | awk '{print $1 " " $2}'| rev)
			plate=""
# IF IMPLEMENTING ALPR:
# put lisence plate into varible plate

			if [[ $plate == "" ]] && [[ $(lsof | grep "$filename") == "" ]]
			then
				mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(VIDDIR,TIME) VALUES('/camEvents/$fileName','$time')"
			else
				mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(PLATE,VIDDIR,TIME) VALUES('$plate','/camEvents/$fileName','$time')"
			fi

			# Move to the storage for html in server.
			# This has a soft link to the storage device if it is set.
			mv "$i" "/srv/http/camEvents"
			fi
	done
	# stop infinite loop from using all resources of there is no event 
	sleep 10
done
