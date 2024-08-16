<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $idProgramme = $_POST['idProgramme'];
    $idTrash = $_POST['idTrash'];
    $poids = $_POST['poids'];
    $dateRamassage = $_POST['dateRamassage'];

    $query = "INSERT INTO ramassage(idProgramme, idTrash, idPersonne, poids, dateRamassage) VALUES('$idProgramme', '$idTrash', '$idPersonne', '$poids', '$dateRamassage')";

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