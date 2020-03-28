<html>
<link rel="stylesheet" href="style.css">
<body>
<?php
include 'auth.php';	
include 'dbConnect.php';


function findVendor($mac){
	include 'dbConnect.php';
	$conn = $connection->query ("select VENDOR from BEACON where MAC = '".$mac."' and VENDOR != '' LIMIT 1");
	while ($row = $conn->fetch()) {
		$vendor=$row['VENDOR'];
	}
	return $vendor;
}

$conn = $connection->query("select VIDDIR, PLATE, TIME from CAMEVENT where VIDID = ". $_POST['event']);
while ($row = $conn->fetch()) {
	$vidDir=$row['VIDDIR'];
	$plate=$row['PLATE'];
	$time=$row['TIME'];
}

echo '<table class="mainTable">
	<tr><td>Video<br><center>
	<video src="'.$vidDir.'" type=\'video/x-matroska; codecs="theora, vorbis"\' autoplay controls></video></center></td>';
$scannerResults='
	</tr><tr><td><center>List of devices<center><br><table><td>Mac address</td><td>Device vendor</td><td>Wifi Name</td>
	<td>Location</td><td>Approximate address</td><td><center>Show on<br>Google maps</center></td><td>Last seen</td> ';
$resultNum=0;
$conn = $connection->query ("select ADDRESS,MAC,ESSID,TIME,TRILAT,TRILONG,LASTSEEN from SCANNER  where ESSID in (select ESSID from BEACON  where TIME < DATE_ADD('".$time."', INTERVAL 30 SECOND) AND TIME > DATE_ADD('".$time."', INTERVAL -30 SECOND))");
while ($row = $conn->fetch()) {

	$macVendor=findVendor($row['MAC']);

	$resultNum.=1;
	$scannerResults.='<tr><td>'.$row['MAC'].'</td><td>'.$macVendor.'</td><td>'.str_replace("+"," ",$row['ESSID']).'</td>
	<td>'.$row['TRILAT'].' , '.$row['TRILONG'].'<td>'.$row['ADDRESS'].'</td><td><form action="http://www.google.com/maps/place/'.$row['TRILAT'].','.$row['TRILONG'].'"> 
	<input type="submit" value="Open" class="bt1" /></form></td>
	</td><td>'.substr(str_replace("-", " ",str_replace('"',' ',str_replace("T", " ",$row['LASTSEEN']))),0,-6).'</td></tr>';
}
if ($resultNum == 0)
{
	echo '</tr><tr><td><center>No wifi beacons found.<br>
		There may still however be some waiting to be processed in the backlog.</center></td></tr>';
}
else{

	echo $scannerResults;
}

echo '</table></center></td></tr>
<tr><td></td></tr>
</table>';
?>


</body>
</html>

</form>
