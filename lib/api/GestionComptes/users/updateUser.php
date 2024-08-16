<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $trashCash = $_POST['trashCash'];
    $fonction = $_POST['fonction'];

    $query = "UPDATE users SET trashCash='$trashCash', fonction='$fonction' WHERE idPersonne='$idPersonne'";

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