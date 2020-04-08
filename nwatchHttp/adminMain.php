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
cat: cat: No such file or directory
<html>                                                                                                                                                                                                                                    
<link rel="stylesheet" href="style.css">                                                                                                                                                                                                  
<body>                                                                                                                                                                                                                                    
   <table class="mainTable">                                                                                                                                                                                                              
   <tr>                                                                                                                                                                                                                                   
           <td>                                                                                                                                                                                                                           
                   <p class="bold">Events</p>                                                                                                                                                                                             
                   <?php                                                                                                                                                                                                                  
                           include 'dbConnect.php';                                                                                                                                                                                       
                           include 'adminAuth.php';                                                                                                                                                                                       
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
                                   <form action="/event.php" method="post" target="_blank">                                                                                                                                                               
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
<table>
<tr><td>
<form action="/showLog.php" method="post">
        <input class="bt1" type="submit" value="Show log">
</form></td><td>
<form action="/showLog.php" method="post">
        <input class="bt1" type="submit" value="Start nwatch">
</form></td><td>
<form action="/showLog.php" method="post">
        <input class="bt1" type="submit" value="Stop nwatch">
</form></td></tr>
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
