<?php
    require_once '../../connectionDB.php';

    $idTrash = $_POST['idTrash'];
    $statut = $_POST['statut'];

    $query = "UPDATE trash SET statut='$statut' WHERE idTrash='$idTrash'";

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