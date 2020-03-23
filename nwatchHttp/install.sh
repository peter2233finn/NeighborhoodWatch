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
sudo touch $logDir
sudo chmod 777 $logDir
sudo chmod 777 -R /etc/nwatch
sudo chmod 777 -R /var/nwatch

sudo pacman -S base-devel linux-raspberrypi4-headers dkms
sudo pacman -S unzip wget motion mysql php php-sqlite php-apache php-pgsql ffmpeg curl make  
systemctl enable mysqld
systemctl enable httpd
cp -r nwatchHttp/* /srv/http/

# Doenload the MAC address out file
wget http://standards-oui.ieee.org/oui.txt -P /etc/nwatch
pip install pycurl

#wget https://github.com/umlaeute/v4l2loopback/archive/master.zip
#unzip master.zip
#cd v4l2loopback-master
#make
#sudo make install
#sudo modprobe v4l2loopback

cp -r camera /var/nwatch
cp -r installFiles/php.ini /etc/php/php.ini
cp -r installFiles/motion.conf /etc/motion
cp -r wifi /var/nwatch
cp -r nwatchHttp/* /srv/http

echo "Adding user nwatch"
mkdir /home/nwatch
useradd nwatch -d /home/nwatch/
echo "Enter the password for the user nwatch"
passwd nwatch

#sudo sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/g' /etc/httpd/conf/httpd.conf
#sudo sed -i 's/#LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so/LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so/g' /etc/httpd/conf/httpd.conf
# NOTE THIS WILL KEEP ADDING IF INSTALLER IS RAN AND >> DOESNT WORK FOR SUDO
#echo "LoadModule php7_module modules/libphp7.so" >> /etc/httpd/conf/httpd.conf
#echo "AddHandler php7-script .php" >> /etc/httpd/conf/httpd.conf
#Add this: "Include conf/extra/php7_module.conf" to end of include section
sudo cp installFiles/httpd.conf /etc/httpd/conf/httpd.conf
sudo cp installFiles/php.ini /etc/php/php.ini

# Enable the database
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
mysql_secure_installation

echo "Enter password for mysql root user to install the database:"
read dbPass
mysql -u root -p"$dbPass" < file.sql

# Install v4l2loopback for the camera
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Sy
yay -S v4l2loopback-dkms
sudo dkms autoinstall

sudo reboot
