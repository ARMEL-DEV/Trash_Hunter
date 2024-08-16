<?php
    header("Access-Control-Allow-Origin:*");
    header("Access-Control-Allow-Headers:Origin,Content-Type");

    function connexionPDO(){
        $DB_HOST = "localhost";
        $DB_NAME = "dshcente_trashhunter";
        $DB_USER = "dshcente_trashhunter";
        $DB_PASS = "Tr@shHunter2023";
        try{
            $con = new PDO("mysql:host=$DB_HOST;dbname=$DB_NAME;",$DB_USER,$DB_PASS);
            return $con;
        }
        catch(PDOException $e){
            print "erreur de connexion PDO ";
            echo $e->getMessage();
            die();
        }
    }
?>
