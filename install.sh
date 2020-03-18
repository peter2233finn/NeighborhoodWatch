if (( $UID != 0 ))
then
	echo "The install needs root permissions"
	exit 0
fi

sudo rm -r /etc/nwatch
sudo mkdir /etc/nwatch
sudo mkdir /var/nwatch
sudo mkdir /srv/http/nwatch
. /etc/nwatch.conf
sudo touch $logDir
sudo chmod 777 $logDir
sudo chmod 777 -R /etc/nwatch
sudo chmod 777 -R /var/nwatch
#pip install pycurl
# sudo pacman -S motion
# wget https://github.com/umlaeute/v4l2loopback/archive/master.zip
# unzip master.zip
# cd v4l2loopback-master
# make
# sudo make install
# sudo modprobe v4l2loopback

cp -r camera /var/nwatch
cp -r installFiles/nwatch.conf /etc/nwatch.conf
cp -r installFiles/motion.conf /etc/motion
cp -r wifi /var/nwatch
cp -r nwatchHttp/* /srv/http/nwatch
