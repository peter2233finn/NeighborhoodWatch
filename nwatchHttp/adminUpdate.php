<?php
session_start();
include 'adminAuth.php';
include 'auth.php';
include 'dbConnect.php';
$userID=1;
if( isset($_POST['delEvent']) ){
        include 'adminAuth.php';
        $h = $conn->query("delete from CAMEVENT where VIDID = '". $_POST['delEvent'] ."'");
        $msg.="Event has been deleted";
        setcookie("msg","Event has been deleted.");
        header("Location: adminMain.php");
        die();
}
if( isset($_POST['cur']) ){
        $pwd = $conn->query("select password from USERS WHERE USERID = '". $userID ."'");

        while ($row = $pwd->fetch()) {
                        $password= $row['password'];
                }
        if($password === $_POST["cur"]){

                if($_POST["new1"] === $_POST["new2"]){

                        if($_POST["new1"]==NULL){
                                $msg="Please enter something for the new password";
                        }
                        else{
                                $updated = $conn->query("UPDATE USERS SET PASSWORD='".$_POST["new1"]."' WHERE USERID = ". $userID);

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
        $whiteList=explode("\n", $_POST["wl"]);
        foreach ($whiteList as $item) {
                $conn = $connection->query("INSERT INTO LISTS(WLIST, USERID) VALUES('".$item."','". $userID."')");
        }
        foreach ($blackList as $item) {
                $conn = $connection->query("INSERT INTO LISTS(BLIST, USERID) VALUES('".$item."','". $userID."')");
        }
        $msg.="The lists have been updated";
}
$_SESSION["msg"]=$msg;
header("Location: adminMain.php");
?>
