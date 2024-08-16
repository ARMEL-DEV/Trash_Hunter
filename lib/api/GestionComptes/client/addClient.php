<?php
    require_once '../../connectionDB.php';
          
    $idPersonne = $_POST['idPersonne'];
    $idGain = $_POST['idGain'];
    $Cli_idPersonne = $_POST['Cli_idPersonne'];
    $longitude = $_POST['longitude'];
    $latitude = $_POST['latitude'];
    $dateSubscription = $_POST['dateSubscription'];
    $nombreAppel = $_POST['nombreAppel'];

    $query_insert = "INSERT INTO client(idPersonne, idGain, Cli_idPersonne, latitude, longitude, dateSubscription, nombreAppel) VALUES('$idPersonne', '$idGain', '$Cli_idPersonne', '$latitude', '$longitude', '$dateSubscription', '$nombreAppel')";

    try{
        $req_insert = connexionPDO()->prepare($query_insert);
        $execQuery = $req_insert->execute();
    }
    catch(PDOException $e){
        print "Erreur de connexion PDO";
        die();
    }

    if($execQuery){
        json_encode(array("code" => 1, "message" => "Enregistrement éffectué avec succès."));
    } else {
        json_encode(array("code" => 2, "message" => "Erreur lors de l'enregistrement !"));
    }
?>