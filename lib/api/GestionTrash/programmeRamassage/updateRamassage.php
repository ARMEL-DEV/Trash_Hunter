<?php
    require_once '../../connectionDB.php';

    $idProgramme = $_POST['idProgramme'];
    $zone = $_POST['zone'];
    $dateProgrammation = $_POST['dateProgrammation'];

    $query = "UPDATE programmeramassage SET zone='$zone', dateProgrammation='$dateProgrammation' WHERE idProgramme='$idProgramme'";

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