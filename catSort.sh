. /etc/nwatch.conf

for i in *;
do
	if [[ ${i: -3} == "mkv" ]]
	then
		echo $i

		time=${i:: -4} 
		plate=""
#	do alpr stuff here
# 	put into varible plate

		if [[ $plate == "" ]]
		then
			mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(VIDDIR,TIME) VALUES('/var/nwatch/$i','$time')"
		else
			mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(PLATE,VIDDIR,TIME) VALUES('$plate','/var/nwatch/$i','$time')"
		fi
		mv "$i" /var/nwatch
	fi

done
