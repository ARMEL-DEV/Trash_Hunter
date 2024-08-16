<?php
    require_once '../../connectionDB.php';

    $idGain = $_POST['idGain'];
    $description = $_POST['description'];

    $query = "UPDATE gain SET description='$description' WHERE idGain='$idGain'";

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