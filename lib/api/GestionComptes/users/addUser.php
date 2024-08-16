<?php
    require_once '../../connectionDB.php';
          
    $idPersonne = $_POST['idPersonne'];
    $trashCash = $_POST['trashCash'];
    $fonction = $_POST['fonction'];

    $query_insert = "INSERT INTO users(idPersonne, trashCash, fonction) VALUES('$idPersonne', '$trashCash', '$fonction')";

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