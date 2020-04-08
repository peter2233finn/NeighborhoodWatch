. /etc/nwatch.conf
while true
do
        for i in /var/nwatch/camera/*;
        do
                if [[ ${i: -3} == "mkv" ]]
                then
                        if [[ $storage != "" ]]
                                then
                                if [[ ! -d "$storage/" ]]
                                then
                                        echo "[ERR]: The directory to store videos ($storage) has failed. Exiting. Watchdog will attempt again in 30 seconds"
                                        echo "[ERR]: The videos have not been deleted and are stored in /var/nwatch/camera"
                                        exit
                                fi
                        fi


                        time=$(echo ${i:: -4} | tr "/" " " | rev | awk '{print $1 " " $2}'| rev)
                        fileName=$(echo $i | tr "/" " " | rev | awk '{print $1 " " $2}'| rev)
                        plate=""
#       ALPR to be peformed here if you want to add it.
#       put the lisence plate into varible plate

                        if [[ $plate == "" ]]
                        then
                                mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(VIDDIR,TIME) VALUES('/camEvents/$fileName','$time')"
                        else
                                mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(PLATE,VIDDIR,TIME) VALUES('$plate','/camEvent/$fileName','$time')"
                        fi

                        mv "$i" "/srv/http/camEvents"
                        fi
        done
        sleep 10
done
