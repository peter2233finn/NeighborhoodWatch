<html>                                                                                                                                                                                                                                    
<link rel="stylesheet" href="style.css">                                                                                                                                                                                                  
<body>
<form action="/showLog.php" method="post">
  <label for="rows">Log lines</label>
  <input type="number" name="rows" value="500" style="width: 10%;" min="0">
  <label for="cols">Display in columns</label>
  <input type="number" name="cols" value="3" style="width: 10%;" min="0">
  <input type="submit" class="bt1" value="Update">
</form>
<?php
include 'adminAuth.php';
if(isset($_POST['rows'])){
	$rowNum=intval($_POST['cols']);
	$lineNum=intval($_POST['rows']);

}
else{
	$rowNum=1;
	$lineNum=1000;
}
$log = file("nwatch.log") or die("Error: Unable to open the log file<br>
	There should be a symbolic link between the log directory and the file nwatch.log in the server folder");
echo "<font size=8>Neighbourhood watch system log</font><br><br><center><table>";

$newLine=0;
$linesToPrint=count($log)*$lineNum;
for ($i = count($log)-1; $i >= count($log)-$lineNum; $i--) {
	echo "<td>";
	echo $log[$i] . "</td>";
	if($newLine%$rowNum == ($rowNum-1)){
		echo "</tr>";
	}
	if($log[$i] == ""){
		break;
	}
	$newLine++;
}
if(count($log)==0){
	echo '<tr><td>There is noting in the log file</td></tr>';
}
echo "</table></center>";

fclose($log);

?>
</body>
</html>
