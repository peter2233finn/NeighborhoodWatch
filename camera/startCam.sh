. /etc/nwatch.conf

# Entire if statment checks if the connection should be http or https
# This formats the camera URL that will work with ffmpeg and v4l2loopback
# The format is http://user:pass@(URL)
httpType=$camURL
if [[ $httpType == *"https"*  ]]
then
        http="https://"
else
        http="http://"
fi
camURL=$(echo $camURL | sed 's/https:\/\///')
camURL=$(echo $camURL | sed 's/http:\/\///')

# Checks if the camera has a username set in /etc/nwatch.conf
# If it doesnt, assume there is no bacic authentication
if [[ $camUser == "" ]]
then
	camURL="$http""$camURL"
else
	camURL="$http""$camUser"":""$camPass""@""$camURL"
fi
# Start the camera using ffmpeg
sudo ffmpeg -re -i "$camURL" -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0 2> /dev/null > /dev/null
