<?php
if(!isset($_COOKIE['LogUser'])){
	setcookie("error","Please login to see this page.");
	header("Location: index.php");
}
?>
