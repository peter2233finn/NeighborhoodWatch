<?php
$connection = new PDO("mysql:host=localhost;dbname=nwatch", "watch", "3342234Pp&^");

//check for cookie admin
if($_COOKIE['LogUser'] == "admin"){
	adminConsole();
}

//check if admin just logged in
elseif ($_POST['user'] == 'admin')
{
	authAdmin();
}

//check if normal user just logged in
else{
	userAuth();
}

function authAdmin(){

	include "dbConnect.php";
	$conn = $connection->query("select userid,username,password from USERS WHERE USERNAME = 'admin'");
	while ($row = $conn->fetch()) {
		$adPas=$row['password'];
		$UserID=$row['userid'];
	}
	if ($adPas != $_POST['pas']){
		loginFailed("Admin");
	}

	else{
		adminConsole();
	}

}

function userAuth(){
	include "dbConnect.php";
	$user = $conn->query("SELECT * FROM USERS where username = '".$_POST[user]."'");

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

function adminConsole(){


	//for dropdown menu
	echo '<script>function myFunction() { document.getElementById("myDropdown").classList.toggle("show");}';
	echo 'window.onclick = function(event) { if (!event.target.matches(\'.dropbtn\')) { var dropdowns = document.getElementsByClassName("dropdown-content");';
       	echo 'var i; for (i = 0; i < dropdowns.length; i++)'; 
	echo "{ var openDropdown = dropdowns[i]; if (openDropdown.classList.contains('show')) { openDropdown.classList.remove('show'); } } } } </script>";


	include "dbConnect.php";
	setcookie("LogUser","admin", time() + (86400 * 30), "/");
	echo '<link rel="stylesheet" href="style.css">';
	echo '<table class="disUser"><th></th><th>Username</th><th>First name</th><th>Last name</th><th>House number</th>';
	echo '<form method="post" action="login.php">';
	$stmt = $conn->query("SELECT * FROM USERS");
	while ($row = $stmt->fetch()) {
		echo '<tr><td><input type="checkbox" name="'.$row['USERID'].'"></td><td>';
		echo $row['USERNAME']."</td><td>".$row['FNAME']."</td><td>".$row['LNAME']."</td><td>".$row['HOUSE']."</td></tr>";
	}
	echo '<tr><td><select class="bt1" name="action">
               <option value = "mod">Edit users</option>
               <option value = "del">Delete users</option>
               <option value = "add">Add user</option>
	     </select></td><td><input class="bt1" type="submit" value="Submit"></form></td></tr></table>';
	
	if($_POST["action"] == "del"){

		foreach($_POST as $key => $value)
		{
			if(is_int((int)$key) && $key != "action"){
				$conn->query("DELETE FROM LISTS WHERE USERID = '". $key."'");
				$conn->query("DELETE FROM USERS WHERE USERID = '". $key."'");
				echo "X".$key."X\n";
				$_POST = array();
			}
		}
	}


	elseif($_POST["action"] == "mod"){
		echo "<br><br><table><tr><td>Username</td><td>Firstname</td><td>Last name</td><td>House number</td><td>New password</td><td>Repeat password";
		echo '<form method="post" action="login.php"></td>';
		foreach($_POST as $key => $value)
		{
			$edit=$conn->query("SELECT * FROM USERS WHERE USERID = '". $key."'");
			while ($row = $edit->fetch()) {
				echo '<tr>
					<td><input type="text" name="'.$row["USERID"].' user" value="'.$row["USERNAME"].'"></td>
					<td><input type="text" name="'.$row["USERID"].' fname" value="'.$row["FNAME"].'"></td>
					<td><input type="text" name="'.$row["USERID"].' lname" value="'.$row["LNAME"].'"></td>
					<td><input type="text" name="'.$row["USERID"].' add" value="'.$row["HOUSE"].'"></td>
					<td><input type="password" name="'.$row["USERID"].' pas1"></td>
					<td><input type="password" name="'.$row["USERID"].' pas2"></td></tr>';
			}

		}
		echo '<tr><td>
			  <input type="hidden" id="action2" name="action" value="doUpdate">
			  <input type="submit" class="bt1" value="Update"></td></tr></form></table>';
		//header("Location: login.php");
		
	}
	elseif($_POST["action"] == "doUpdate"){
		$numUpdates=(sizeof($_POST)-1)/6;
		$query=$conn->query("SELECT MAX(USERID) FROM USERS");
		$num=$query->fetch();
		
		for ($x = 0; $x <= $num[0]; $x++) {
			if(isset($_POST[$x."_user"])){

				if($_POST[$x."_pas1"] != "" && $_POST[$x."_pas2"] != ""){
					if($_POST[$x."_pas1"] == $_POST[$x."_pas2"]){
				
						$sql="UPDATE USERS SET FNAME='".$_POST[$x."_fname"]."',
					    LNAME='".trim($_POST[$x."_lname"],"\v")."
					    ',HOUSE='".trim($_POST[$x."_add"],"\v")."
					    ',USERNAME='".trim($_POST[$x."_user"],"\v")."
					    ',PASSWORD='".$_POST[$x."_pas1"]."
					    ' WHERE USERID=".$x.";";
					$query=$conn->query($sql);
					echo "Updated ".$_POST[$x."_user"].".<br>";
					}
					else{
						echo "Error: The passwords you entered for ".$_POST[$x."_user"]." do not match.<br>";
					}
				}
				else{
					$query=$conn->query("UPDATE USERS SET FNAME='".$_POST[$x."_fname"]."',
					    LNAME='".$_POST[$x."_lname"]."
					    ',HOUSE='".$_POST[$x."_add"]."
					    ',USERNAME='".$_POST[$x."_user"]."
					    ' WHERE USERID=".$x);
					echo "Updated ".$_POST[$x."_user"]." with no change to the pasword<br>";
				}
			}
		}
	}

	elseif($_POST["action"] == "add"){
		echo '<br>Add user:
		<br><br><table><tr><td>Username</td><td>Firstname</td><td>Last name</td><td>House number</td><td>New password</td><td>Repeat password
		<form method="post" action="login.php"></td><tr>
		<td><input type="text" name="user"></td>
		<td><input type="text" name="fname"></td>
		<td><input type="text" name="lname"></td>
		<td><input type="text" name="add"></td>
		<td><input type="password" name="pas1"></td>
		<td><input type="password" name="pas2"></td></tr>
		<tr><td>
		<input type="hidden" id="action2" name="action" value="doAdd">
		<input type="submit" class="bt1" value="Update"></td></tr></form></table>';


	}
	elseif($_POST["action"] == "add"){

	}
	//fix php crap
	$query=$conn->query("
	UPDATE USERS SET USERNAME = TRIM(CHAR(9) FROM TRIM(USERNAME));
	UPDATE USERS SET PASSWORD = TRIM(CHAR(9) FROM TRIM(PASSWORD));
	UPDATE USERS SET FNAME = TRIM(CHAR(9) FROM TRIM(FNAME));
	UPDATE USERS SET LNAME = TRIM(CHAR(9) FROM TRIM(LNAME));
	UPDATE USERS SET HOUSE = TRIM(CHAR(9) FROM TRIM(HOUSE));
	UPDATE USERS SET USERNAME = TRIM(CHAR(10) FROM TRIM(USERNAME));
	UPDATE USERS SET PASSWORD = TRIM(CHAR(10) FROM TRIM(PASSWORD));
	UPDATE USERS SET FNAME = TRIM(CHAR(10) FROM TRIM(FNAME));
	UPDATE USERS SET LNAME = TRIM(CHAR(10) FROM TRIM(LNAME));
	UPDATE USERS SET HOUSE = TRIM(CHAR(10) FROM TRIM(HOUSE));");

}


?>
