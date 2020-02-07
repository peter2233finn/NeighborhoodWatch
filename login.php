<?php
$connection = new PDO("mysql:host=localhost;dbname=nwatch", "watch", "3342234Pp&^");


if ($_POST['user'] == 'admin')
{
	$auth = $connection->query("select userid,username,password from USERS WHERE USERNAME = 'admin'");
	while ($row = $auth->fetch()) {
		$adPas=$row['password'];
		$UserID=$row['userid'];
	}
$stmt = $connection->query("SELECT * FROM USERS");
	if ($adPas != $_POST['pas']){
		loginFailed("Admin");
	}
	else{
		setcookie("LogUser",$userId, time() + (86400 * 30), "/");
		echo '<link rel="stylesheet" href="style.css">';
		echo '<table class="disUser"><th>Username</th><th>First name</th><th>Last name</th><th>House number</th>';

		while ($row = $stmt->fetch()) {
			echo "<tr><td>".$row['USERNAME']."</td><td>".$row['FNAME']."</td><td>".$row['LNAME']."</td><td>".$row['HOUSE']."</td></tr>";
		}
	
	}

}
else{

	$user = $connection->query("SELECT * FROM USERS where username = '".$_POST[user]."'");

	while ($row = $user->fetch()) {
		$adPas=$row['PASSWORD'];
		$userId=$row['USERID'];
	}

	if ($adPas != $_POST['pas']){
		loginFailed($_POST['user']);
	}
	else{

		setcookie("LogUser",$userId, time() + (86400 * 30), "/");
		header("Location: main.php");
	}
}


function loginFailed($user){
	setcookie("error","Sorry $user, Login failed. please try again");
	header("Location: index.php");
}



echo "</table>";
?>
