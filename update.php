<html>
<link rel="stylesheet" href="style.css">
<body>
<?php
include 'auth.php';
include 'dbConnect.php';

if( isset($_POST['cur']) ){
	$pwd = $conn->query("select password from USERS WHERE USERID = '". $_COOKIE['LogUser'] ."'");
	
	while ($row = $pwd->fetch()) {
			$password= $row['password'];
		}
	if($password === $_POST["cur"]){
		
		if($_POST["new1"] === $_POST["new2"]){

			if($_POST["new1"]==NULL){
				$msg="Please enter something for the new password";
			}
			else{
				$updated = $conn->query("UPDATE USERS SET PASSWORD='".$_POST["new1"]."' WHERE USERID = ". $_COOKIE['LogUser']);
			
				$msg="Your password was sucessfully updated";
			}
		}
		else{
			$msg="The passwords you entered do not match.";
		}


	}
	else{
		$msg="The password you entered is wrong. Please try again.";
	}

}
else{

	$blackList=explode("\n", $_POST["bl"]);
	$whiteList=explode("\n", $_POST["bl"]);
//	foreach ($array as $item) {
//		echo "ZZZ" . $item;
//	}

	//echo $_POST["bl"];



}

setcookie("msg",$msg);

header("Location: main.php");

?>

</body>
</html>
