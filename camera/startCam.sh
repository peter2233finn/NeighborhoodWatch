. /etc/nwatch.conf

ffmpeg -re -i "$camURL" -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0 -loglevel 2

