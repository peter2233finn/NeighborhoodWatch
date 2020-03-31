<?php
$connection = new PDO("mysql:host=localhost;dbname=nwatch", "watch", "3342234Pp&^");
$msg="";
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

	echo $msg;
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
		echo '<tr><td width="1%"><input type="checkbox" name="'.$row['USERID'].'"></td><td>';
		echo $row['USERNAME']."</td><td>".$row['FNAME']."</td><td>".$row['LNAME']."</td><td>".$row['HOUSE']."</td></tr>";
	}
	echo '<tr><td><select class="bt1" name="action">
               <option value = "mod">Edit users</option>
               <option value = "del">Delete users</option>
               <option value = "add">Add user</option>
	        </select></td><td><input class="bt1" type="submit" value="Submit"></form></td><td>
		<form action="/adminMain.php" method="post">
		<input type="submit" value="Show events" class="bt1">                                                                                                                                                   
		</form></td></tr></table>';

	if($_POST["action"] == "del"){
		$ter=0;
		foreach($_POST as $key => $value)
		{
			if(is_int((int)$key) && $key != "action"){
				if ($key == 1){
					$msg.="NOTE: you cannot delete the admin user.<br>";
				}
				else{
					$conn->query("DELETE FROM LISTS WHERE USERID = '". $key."'");
					$conn->query("DELETE FROM USERS WHERE USERID = '". $key."'");
					if($ter==1){
						$ter=1;
						$msg.="Deleted users.<br>";
					}
				}
			}
		}
		$_POST = array();
	echo $msg;
	}


	elseif($_POST["action"] == "mod" && count($_POST) != 1){
		echo "<br><br><table><tr><td>Username</td><td>Firstname</td><td>Last name</td><td>House number</td><td>New password</td><td>Repeat password";
		echo '<form method="post" action="login.php"></td>';
		foreach($_POST as $key => $value)
		{
			$edit=$conn->query("SELECT * FROM USERS WHERE USERID = '". $key."'");
			while ($row = $edit->fetch()) {
				echo '<tr>
					<td><input type="text" name="'.$row["USERID"].' user" value="'.$row["USERNAME"].'" required></td>
					<td><input type="text" name="'.$row["USERID"].' fname" value="'.$row["FNAME"].'" required></td>
					<td><input type="text" name="'.$row["USERID"].' lname" value="'.$row["LNAME"].'" required></td>
					<td><input type="text" name="'.$row["USERID"].' add" value="'.$row["HOUSE"].'" required></td>
					<td><input type="password" name="'.$row["USERID"].' pas1"></td>
					<td><input type="password" name="'.$row["USERID"].' pas2"></td></tr>';
			}

		}
		echo '<tr><td>
			  <input type="hidden" id="action2" name="action" value="doUpdate">
			  <input type="submit" class="bt1" value="Update"></td></tr></form></table>';
		//header("Location: login.php");
		
	echo $msg;
	}
	elseif($_POST["action"] == "doAdd"){
		if ($_POST['pas1'] == $_POST['pas2']){
			$stmt = $conn->query("SELECT USERNAME FROM USERS");
			$identicalSetter=0;
			while ($row = $stmt->fetch()) {
				if($row['USERNAME'] == $_POST['user']){
					$identicalSetter=1;
					break;
				}
			}	
			if($identicalSetter == 0){
				if($_POST["pas1"] != "" && $_POST["pas2"] != ""){
					if($_POST["pas1"] == $_POST["pas2"]){
						$conn->query("insert into USERS(FNAME,LNAME,HOUSE,USERNAME,PASSWORD) values('".$_POST['fname']."','".$_POST['lname']."','".$_POST['add']."','".$_POST['user']."','".$_POST['pas1']."');");
						$msg.="The new user has been added.";
					}			
					else{
						$msg.="Passwords for user ".$_POST[$x."_user"]." don't match. Try again.<br>";
					}
				}
				else{
					$msg.="Please add a password for the user";
				}
			}
			elseif($identicalSetter==1){
				echo "Another user has that username. <br>There cannot be identical usernames.";
			}
			
		}
		else{
			$msg.="The passwords dont match. Try again.";
		}
	echo $msg;
}
	elseif($_POST["action"] == "doUpdate" && count($_POST) != 1){
		$numUpdates=(sizeof($_POST)-1)/6;
		$query=$conn->query("SELECT MAX(USERID) FROM USERS");
		$num=$query->fetch();
		for ($x = 0; $x <= $num[0]; $x++) {

			if(isset($_POST[$x."_user"])){
				if($x == 1){
					$username="admin";
					$msg.="NOTE you cannot change the admin username.<br>";
				}
				else{
					$username=trim($_POST[$x."_user"]);
				}
				$identicalSetter=0;
				$check = $conn->query("SELECT USERNAME FROM USERS WHERE USERID != ".$x);
				while ($row = $check->fetch()) {
					if($row['USERNAME'] == $username){
						$identicalSetter=1;
						break;
					}
				}
				if($_POST[$x."_pas1"] != "" && $_POST[$x."_pas2"] != ""){
					if($_POST[$x."_pas1"] == $_POST[$x."_pas2"]){
						if($identicalSetter == 1){
							$msg.="A user with the username ".$username." already exists.";
						}
						else{
							$msg.= "Updated user ".trim($_POST[$x."_user"],"\v").".<br>";
							$sql="UPDATE USERS SET FNAME='".trim($_POST[$x."_fname"],"\v")."',
						    LNAME='".trim($_POST[$x."_lname"],"\v")."
						    ',HOUSE='".trim($_POST[$x."_add"],"\v")."
						    ',USERNAME='".trim($username,"\v")."
						    ',PASSWORD='".trim($_POST[$x."_pas1"],"\v")."
						    ' WHERE USERID=".$x.";";
							$query=$conn->query($sql);
						}
					}			
					else{
						$msg.="Passwords for user ".$_POST[$x."_user"]." don not match. Try again.<br>";
					}
				}
			
				else{
					if($identicalSetter==1){
						$msg.="A user with the username ".$username." already exists.";
					}
					else{
						$query=$conn->query("UPDATE USERS SET FNAME='".$_POST[$x."_fname"]."',
						    LNAME='".trim($_POST[$x."_lname"],"\v")."
						    ',HOUSE='".trim($_POST[$x."_add"],"\v")."i
						    ',USERNAME='".trim($username,"\v")."
						    ' WHERE USERID=".$x);
						echo "Updated user ".trim($_POST[$x."_user"])." with no change to the password<br>";
					}
				}
			}
		}
	echo $msg;
	}

	elseif($_POST["action"] == "add"){
		echo '<br>Add user:
		<br><br><table><tr><td>Username</td><td>Firstname</td><td>Last name</td><td>House number</td><td>New password</td><td>Repeat password
		<form method="post" action="login.php"></td><tr>
		<td><input type="text" name="user" required></td>
		<td><input type="text" name="fname" required></td>
		<td><input type="text" name="lname" required></td>
		<td><input type="text" name="add" required></td>
		<td><input type="password" name="pas1" required></td>
		<td><input type="password" name="pas2" required></td></tr>
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
