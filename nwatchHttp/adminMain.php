<?php
include 'auth.php';
include 'dbConnect.php';

if( isset($_POST['delEvent']) ){
        include 'adminAuth.php';
        $pwd = $conn->query("delete from CAMEVENT where VIDID = '". $_POST['delEvent'] ."'");
        $msg.="Event has been deleted";
        setcookie("msg",$msg);
        header("Location: adminMain.php");
        die();
}
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
        $whiteList=explode("\n", $_POST["wl"]);
        foreach ($whiteList as $item) {
                $conn = $connection->query("INSERT INTO LISTS(WLIST, USERID) VALUES('".$item."','". $_COOKIE['LogUser']."')");
        }
        foreach ($blackList as $item) {
                $conn = $connection->query("INSERT INTO LISTS(BLIST, USERID) VALUES('".$item."','". $_COOKIE['LogUser']."')");
        }
}

setcookie("msg",$msg);

header("Location: main.php");

?>
