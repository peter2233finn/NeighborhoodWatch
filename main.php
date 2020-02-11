
<html>
<link rel="stylesheet" href="style.css">
<body>
	<table class="mainTable">
	<tr>
		<td>cam feed</td>
		<td>
			<p class="bold">Car feed</p> 
			<table class="carFeedTable">
				<tr> 
					<th>reg num</th><th>num of devices</th>
				</tr>
			</table>
		</td>

		<tr>
			<td>
				<p class="bold">Settings</p>
				<table>
				<tr>
					<td>Vehicle settings</td>
					<td>Account settings</td>
				</tr>
				<tr>

				<td>
Whitelist vehicles
<form action="/update.php" method="post">
<?php

	include 'auth.php';	
	include 'dbConnect.php';
	$conn = $connection->query("SELECT BLIST,WLIST FROM LISTS where USERID = '".  $_COOKIE['LogUser']  ."'");

	$WLIST="";
	$BLIST="";
	$bRows=0;
	$wRows=0;
	while ($row = $conn->fetch()) {
		if ($row['BLIST'] != NULL){
			$BLIST.=$row['BLIST']."\n";
			$bRows++;
		}
		if ($row['WLIST'] != NULL){
			$WLIST.=$row['WLIST']."\n";
			$wRows++;
		}
	}
	
	echo '<textarea class="tb" rows="'.($wRows+1).'" cols="30" name="wl">'.$WLIST.'</textarea><br>Blacklist vehicles<br><textarea class="tb" rows="'.($bRows+1);
	echo '" type="text" name="bl">'.$BLIST.'</textarea>';

	if(isset($_COOKIE["msg"])){	
		echo "<script>alert('". str_replace("+"," ",($_COOKIE["msg"]))."')</script>";
		setcookie("msg", "", time() - 3600);
	}
?>


<br><br>
<input class="bt1" type="submit" value="Update">
</form>
				</td>

				<td>
<form action="/update.php" method="post">
Current password <input type="password" name="cur"><br>
New password <input type="password" name="new1"><br>
New password <input type="password" name="new2"><br>
<br><br>
<input class="bt1" type="submit" value="Update">
</form>
				</td>
				</tr>
				</table>

			</tr>
		</tr>
	</tr>
	</table>

</body>
</html>

</form>
