
<html>
  <link rel="stylesheet" href="style.css">
    <center>
      <body>
        <div class="container">
          <div class="center">
  	    Username<br>
	    <form action="login.php" method="post">

  	      <input id="textBox" type="text" name="user"><br>
  	      Password<br>
	      <input id="textBox" type="password" name="pas"><br>
	        <input type="submit" value="Login" class="bt1">
	    </form>
	    <?php
		echo str_replace("+"," ",($_COOKIE["error"]));
		setcookie("error", "", time() - 3600);
		setcookie("LogUser", "", time() - 3600);
	    ?>
	  </div>
        </div>
      </body>
    </center>
</html>
