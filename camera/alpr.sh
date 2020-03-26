. /etc/nwatch.conf
while true
do
        for i in /var/nwatch/camera/*;
        do
                if [[ ${i: -3} == "mkv" ]]
                then
                        time=$(echo ${i:: -4} | tr "/" " " | rev | awk '{print $1 " " $2}'| rev)
                        fileName=$(echo $i | tr "/" " " | rev | awk '{print $1 " " $2}'| rev)
                        plate=""
#       do alpr stuff here
#       put into varible plate

                        if [[ $plate == "" ]]
                        then
                                mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(VIDDIR,TIME) VALUES('/camEvents/$fileName','$time')"
                        else
                                mysql -u $dbUser -p"$dbPassword" nwatch -e"INSERT INTO CAMEVENT(PLATE,VIDDIR,TIME) VALUES('$plate','/camEvent/$fileName','$time')"
                        fi

                        mv "$i" /srv/http/camEvents/
                        fi
        done
        sleep 10
done
