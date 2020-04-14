. /etc/nwatch.conf

# Entire if statment checks if the connection should be http or https
httpType=$camURL
if [[ $httpType == *"https"*  ]]
then
	        http="https://"
	else
		        http="http://"
fi
# Sets the camera URL
camURL=$(echo $camURL | sed 's/https:\/\///')
camURL=$(echo $camURL | sed 's/http:\/\///')
camURL="$http""$camUser"":""$camPass""@""$camURL"

sudo ffmpeg -re -i "$camURL" -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0 2> /dev/null > /dev/null
