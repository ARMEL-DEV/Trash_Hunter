<?php
    require_once '../../connectionDB.php';

    $idAccount = $_POST['idAccount'];
    $idPersonne = $_POST['idPersonne'];
    $statut = $_POST['statut'];

    $query = "UPDATE account SET statut='$statut' WHERE idAccount='$idAccount' AND idPersonne='$idPersonne'";

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