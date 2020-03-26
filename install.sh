#if (( $UID != 0 ))
#then
#	echo "The install needs root permissions"
#	exit 0
#fi
echo "Installing the files into /etc and /var"
sudo cp -r installFiles/nwatch.conf /etc/nwatch.conf
. /etc/nwatch.conf

sudo rm -r /etc/nwatch
sudo mkdir /etc/nwatch
sudo mkdir /var/nwatch
sudo mkdir /srv/http/camEvents/
sudo touch $logDir
sudo chmod 777 $logDir
sudo chmod 777 -R /etc/nwatch
sudo chmod 777 -R /var/nwatch
sudo chmod 777 -R /etc/nwatch.conf
sudo chmod 777 /srv/http/camEvents/



echo "Installing dependancies"

sudo pacman -S base-devel usbutils linux-raspberrypi-headers dkms jq aircrack-ng tcpdump #linux-headers
sudo pacman -S unzip wget motion mysql php php-sqlite php-apache php-pgsql ffmpeg curl make  
systemctl enable mysqld
systemctl enable httpd
cp -r nwatchHttp/* /srv/http/

# Download the MAC address out file
wget http://standards-oui.ieee.org/oui.txt -P /etc/nwatch
pip install pycurl

wget https://github.com/umlaeute/v4l2loopback/archive/master.zip
unzip master.zip
cd v4l2loopback-master
make
sudo make install
sudo depmod -a
sudo modprobe v4l2loopback

sudo cp -r camera /var/nwatch
sudo cp -r installFiles/php.ini /etc/php/php.ini
sudo cp -r installFiles/motion.conf /etc/motion
sudo cp -r wifi /var/nwatch
sudo cp -r nwatchHttp/* /srv/http
sudo cp nwatch /usr/bin/
sudo chmod +x /usr/bin/nwatch

echo "Adding user nwatch"
mkdir /home/nwatch
#useradd nwatch -d /home/nwatch/
#chown nwatch:nwatch /home/nwatch/
#echo "Enter the password for the user nwatch"
#passwd nwatch


sudo cp installFiles/httpd.conf /etc/httpd/conf/httpd.conf
sudo cp installFiles/php.ini /etc/php/php.ini

sudo chmod 777 /etc/php/php.ini
echo extension=pdo.so >> /etc/php/php.ini
echo extension=pdo_mysql >> /etc/php/php.ini
echo extension=pdo_pgsql >> /etc/php/php.ini
echo extension=pdo_sqlite >> /etc/php/php.ini
sudo chmod 644 /etc/php/php.ini

# Enable the database
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo mysql_secure_installation

echo "Enter password for mysql root user to install the database:"
read dbPass

mysql -u root -p"$dbPass" -e"drop user watch@localhost;"
mysql -u root -p"$dbPass" -e"drop database nwatch;"

mysql -u root -p"$dbPass" < installFiles/nwatch.sql

# Install v4l2loopback for the camera
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Sy
#yay -S v4l2loopback-dkms
#sudo dkms autoinstall

#sudo reboot
