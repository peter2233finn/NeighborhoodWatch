<?php
try {
$conn=$connection=new PDO("mysql:host=localhost;dbname=nwatch", "watch", "3342234Pp&^");
}
catch(PDOException $e)
    {
    echo "Error: " . $e->getMessage();
    }
?>
