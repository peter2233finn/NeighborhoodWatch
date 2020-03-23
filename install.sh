if (( $UID != 0 ))
then
	echo "The install needs root permissions"
	exit 0
fi
cp -r installFiles/nwatch.conf /etc/nwatch.conf
. /etc/nwatch.conf

sudo rm -r /etc/nwatch
sudo mkdir /etc/nwatch
sudo mkdir /var/nwatch
sudo mkdir /srv/http/nwatch
sudo touch $logDir
sudo chmod 777 $logDir
sudo chmod 777 -R /etc/nwatch
sudo chmod 777 -R /var/nwatch


sudo pacman -S unzip wget motion mysql php php-sqlite php-apache php-pgsql ffmpeg curl make
systemctl enable mysqld
systemctl enable httpd
cp -r nwatchHttp/* /srv/http/

# Doenload the MAC address out file
wget http://standards-oui.ieee.org/oui.txt -P /etc/nwatch
pip install pycurl

wget https://github.com/umlaeute/v4l2loopback/archive/master.zip
unzip master.zip
cd v4l2loopback-master
make
sudo make install
sudo modprobe v4l2loopback

cp -r camera /var/nwatch
cp -r installFiles/php.ini /etc/php/php.ini
cp -r installFiles/motion.conf /etc/motion
cp -r wifi /var/nwatch
cp -r nwatchHttp/* /srv/http/nwatch
