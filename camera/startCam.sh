. /etc/nwatch.conf
sudo rmmod v4l2loopback
sudo modprobe v4l2loopback
ffmpeg -re -i "$camURL" -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0 -loglevel 2 2>&1
sudo chmod 777 /dev/video0
motion >$logDir 2>&1
