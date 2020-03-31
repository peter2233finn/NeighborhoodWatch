<html>                                                                                                                                                                                                                                    
<link rel="stylesheet" href="style.css">                                                                                                                                                                                                  
<body>                                                                                                                                                                                                                                    
   <table class="mainTable">                                                                                                                                                                                                              
   <tr>                                                                                                                                                                                                                                   
           <td>                                                                                                                                                                                                                           
                   <p class="bold">Events</p>                                                                                                                                                                                             
                   <?php                                                                                                                                                                                                                  
                           include "dbConnect.php";                                                                                                                                                                                       
                           echo "<table class='carFeedTable'>                                                                                                                                                                             
                           <tr><td>Delete</td><th>Time</th><th>Regristration plate</th><th>Open event</th></tr>";                                                                                                                                        
                           $conn = $connection->query("select VIDID,VIDDIR,PLATE,TIME from CAMEVENT ORDER BY TIME DESC");                                                                                                                 
                           while ($row = $conn->fetch()) {                                                                                                                                                                                
                                   if ($row['PLATE'] == null){                                                                                                                                                                            
                                           $plate="No lisence plate";                                                                                                                                                                     
                                   }                                                                                                                                                                                                      
                                   else{                                                                                                                                                                                                  
                                           $plate=$row['PLATE'];                                                                                                                                                                          
                                   }                                                                                                                                                                                                      
                                   echo '<tr><td>
                                           
                <form method="post" action="update.php">
                <input type="hidden" id="action2" name="delEvent" value="'.$row['VIDID'].'">
                <input type="submit" class="bt1" value="Delete">
                </form>
</td><td>'.$row['TIME'].'</td><td>'.$plate.'</td>                                                                                                                                                 
                                   <td>                                                                                                                                                                                                   
                                   <form action="/event.php" method="post">                                                                                                                                                               
                                   <input type="hidden" name="event" value="'.$row['VIDID'].'">                                                                                                                                           
                                   <input type="submit" value="Show event" class="bt1">                                                                                                                                                   
                                   </form>                                                                                                                                                                                                
                                   </td></tr>';                                                                                                                                                                                           

                           }                                                                                                                                                                                                              

                                                      echo '</table></td><td><p class="bold">Settings</p><table>
                                                <tr><td>Vehicle settings</td>
                                                <td>Account settings</td>
                                                </tr><tr><td>Whitelist vehicles<form action="/update.php" method="post">';

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
   <?php
           echo $_COOKIE["msg"];
           unset($_COOKIE["msg"]);
?>

                   </tr>
           </tr>
   </tr>
   </table>
</body>
</html>

</form>
