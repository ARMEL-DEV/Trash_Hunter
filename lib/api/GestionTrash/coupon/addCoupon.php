<?php
    require_once '../../connectionDB.php';
          
    $idPersonne = $_POST['idPersonne'];
    $idGain = $_POST['idGain'];
    $reste = $_POST['reste'];

    $query_insert = "INSERT INTO couponreabonnement(idPersonne, idGain, reste) VALUES('$idPersonne', '$idGain', '$reste')";

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