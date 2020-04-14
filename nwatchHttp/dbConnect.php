<?php
$dbPassword="3342234Pp&^";
try {
$conn=$connection=new PDO("mysql:host=localhost;dbname=nwatch", "watch", $dbPassword);
}
catch(PDOException $e)
    {
    echo "Error: " . $e->getMessage();
    }
?>
