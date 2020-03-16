<html>
<link rel="stylesheet" href="style.css">
<body>
<?php
include 'auth.php';	
include 'dbConnect.php';
$conn = $connection->query("select VIDDIR, PLATE, TIME from CAMEVENT where VIDID = ". $_POST['event']);
while ($row = $conn->fetch()) {
	$vidDir=$row['VIDDIR'];
	$plate=$row['PLATE'];
	$time=$row['TIME'];
}

echo '<table class="mainTable">
	<tr><td>Video<br><center>
	<video src="'.$vidDir.'" type=\'video/x-matroska; codecs="theora, vorbis"\' autoplay controls></video></center></td>
	<td>List of devices<br><table><td>Mac address</td><td>Wifi Name</td>
	<td>Location</td><td><center>Show on<br>Google maps</center></td><td>Last seen</td> ';

$conn = $connection->query ("select MAC,ESSID,TIME,TRILAT,TRILONG,LASTSEEN from SCANNER 
where TIME < DATE_ADD('".$time."', INTERVAL 30 SECOND) AND TIME > DATE_ADD('".$time."', INTERVAL -30 SECOND);");
while ($row = $conn->fetch()) {
	echo '<tr><td>'.$row['MAC'].'</td><td>'.str_replace("+"," ",$row['ESSID']).'</td>
	<td>'.$row['TRILAT'].' , '.$row['TRILONG'].'<td><form action="http://www.google.com/maps/place/'.$row['TRILAT'].','.$row['TRILONG'].'"> 
	<input type="submit" value="Open" class="bt1" /></form></td>
	</td><td>'.substr(str_replace("-", " ",str_replace('"',' ',str_replace("T", " ",$row['LASTSEEN']))),0,-6).'</td></tr>';
}
echo '</table></td></tr>
<tr><td></td></tr>
</table>';
?>


</body>
</html>

</form>
