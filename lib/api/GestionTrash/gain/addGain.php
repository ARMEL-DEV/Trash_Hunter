<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $description = $_POST['description'];
    $dateAjout = $_POST['dateAjout'];

    $query = "INSERT INTO gain(idPersonne, description, dateAjout) VALUES('$idPersonne', '$description', '$dateAjout')";

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