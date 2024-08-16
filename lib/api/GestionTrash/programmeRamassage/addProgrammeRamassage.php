<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $zone = $_POST['zone'];
    $dateProgrammation = $_POST['dateProgrammation'];

    $query = "INSERT INTO programmeramassage(idPersonne, zone, dateProgrammation) VALUES('$idPersonne', '$zone', '$dateProgrammation')";

    try{
        $req = connexionPDO()->prepare($query);
        $execQuery = $req->execute();
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