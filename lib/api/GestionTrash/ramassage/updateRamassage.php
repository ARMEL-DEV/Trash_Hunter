<?php
    require_once '../../connectionDB.php';

    $idRamassage = $_POST['idRamassage'];
    $poids = $_POST['poids'];
    $dateRamassage = $_POST['dateRamassage'];

    $query = "UPDATE ramassage SET poids='$poids', dateRamassage='$dateRamassage' WHERE idRamassage='$idRamassage'";

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