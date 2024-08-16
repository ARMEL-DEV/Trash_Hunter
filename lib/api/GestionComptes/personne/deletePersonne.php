<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_GET['idPersonne'];
    $query = "UPDATE personne SET statut=2 WHERE idPersonne='$idPersonne'";

    try{
        $req = connexionPDO()->prepare($query);
        $execQuery = $req->execute();
    }
    catch(PDOException $e){
        print "Erreur de connexion PDO";
        die();
    }

    if($execQuery){
        json_encode(array("code" => 1, "message" => "Suppression éffectuée avec succès."));
    } else {
        json_encode(array("code" => 2, "message" => "Erreur lors de la suppression !"));
    }
?>