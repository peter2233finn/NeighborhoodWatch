<?php
if($_COOKIE['LogUser'] != 'admin'){
       	setcookie("error","You need to be the Admin to view this page.");
      	header("Location: index.php");
}
?>

