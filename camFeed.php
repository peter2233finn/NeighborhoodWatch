



<?php
#echo '<img class="stream" name="main" id="main" border="0" src="http://a:a@192.168.1.190:8080/video">';
#private $stream = new VideoStream("192.168.1.190:8080/video");
#xhr.open(\'GET\', "192.168.1.192/video", async, "a", "a")
echo '



';


#req.setRequestHeader('Authorization','Basic ' + Base64StringOfUserColonPassword);

?>
<img src="http://192.168.1.190:8080/video"  style="-webkit-user-select: none;margin: auto;">

<script>
var token_ // variable will store the token
var userName = "a"; // app clientID
var passWord = "a"; // app clientSecret
var caspioTokenUrl = "192.168.1.190:8080/video"; // Your application token endpoint  
var request = new XMLHttpRequest(); 

function getToken(url, clientID, clientSecret) {
    var key;           
    request.open("POST", url, true); 
    request.setRequestHeader("Content-type", "application/json");
    request.send("grant_type=client_credentials&client_id="+clientID+"&"+"client_secret="+clientSecret); // specify the credentials to receive the token on request
    request.onreadystatechange = function () {
        if (request.readyState == request.DONE) {
            var response = request.responseText;
            var obj = JSON.parse(response); 
            key = obj.access_token; //store the value of the accesstoken
            token_ = key; // store token in your global variable "token_" or you could simply return the value of the access token from the function
        }
    }
}
// Get the token

function CallWebAPI() {
    var request_ = new XMLHttpRequest();        
    var encodedParams = encodeURIComponent(params);
    request_.open("GET", "192.168.1.190:8080/video", true);
    request_.setRequestHeader("Authorization", "Bearer "+ token_);
    request_.send();
    request_.onreadystatechange = function () {
        if (request_.readyState == 4 && request_.status == 200) {
            var response = request_.responseText;
            var obj = JSON.parse(response); 
            // handle data as needed... 

        }
    }
} 
</script>

<div>
<div id="response">

</div>
<input type="button" class="btn btn-primary" value="Call Web API" onclick="javascript:CallWebAPI();" />

