<?php
    require_once '../../connectionDB.php';

    $idGain = $_POST['idGain'];
    $statut = 2;

    $query = "UPDATE gain SET statut='$statut' WHERE idGain='$idGain'";

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