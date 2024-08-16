<?php
    require_once '../connectionDB.php';
          
    $idPersonne = $_POST['idPersonne'];
    $libelle = $_POST['libelle'];
    $description = $_POST['description'];
    $time = $_POST['time'];
    $image = $_POST['image'];

    $query_insert = "INSERT INTO news(idPersonne, libelle, description, image, time) VALUES('$idPersonne', '$libelle', '$description', '$image', '$time')";

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