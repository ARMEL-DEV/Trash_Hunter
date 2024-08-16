<?php
    require_once '../connectionDB.php';

    $idApp = $_POST['idApp'];
    $name = $_POST['name'];
    $description = $_POST['description'];
    $logo = $_POST['logo'];
    $version = $_POST['version'];

    $query = "REPLACE INTO application (idApp, name, description, logo, version)
            VALUES('$idApp', '$name', '$description', '$logo', '$version')";

    try{
        $req = connexionPDO()->prepare($query);
        $execQuery = $req->execute();
    }
    catch(PDOException $e){
        print "Erreur de connexion PDO";
        die();
    }

    if($execQuery){
        json_encode(array("code" => 1, "message" => "Modification éffectuée avec succès."));
    } else {
        json_encode(array("code" => 2, "message" => "Erreur lors de la modification !"));
    }
?>