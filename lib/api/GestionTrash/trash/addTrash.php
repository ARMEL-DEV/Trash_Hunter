<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $idType = $_POST['idType'];
    $gender = $_POST['gender'];
    $image = $_POST['image'];
    $dateEnregistrement = $_POST['dateEnregistrement'];

    $query = "INSERT INTO trash (idType, idPersonne, gender, image, dateEnregistrement) VALUES ('$idType', '$idPersonne', '$gender', '$image', '$dateEnregistrement')";

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