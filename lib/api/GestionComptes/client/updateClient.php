<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $idGain = $_POST['idGain'];
    $Cli_idPersonne = $_POST['Cli_idPersonne'];
    $longitude = $_POST['longitude'];
    $latitude = $_POST['latitude'];
    $dateSubscription = $_POST['dateSubscription'];
    $nombreAppel = $_POST['nombreAppel'];

    $query = "UPDATE client SET
            idGain='$idGain',
            Cli_idPersonne='$Cli_idPersonne',
            longitude='$longitude',
            latitude='$latitude',
            dateSubscription='$dateSubscription',
            nombreAppel='$nombreAppel'
            WHERE idPersonne='$idPersonne'";

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