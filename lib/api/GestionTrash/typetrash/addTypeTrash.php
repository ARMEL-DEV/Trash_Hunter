<?php
    require_once '../../connectionDB.php';

    $libelle = $_POST['libelle'];
    $description = $_POST['description'];

    $query_insert = "INSERT INTO typetrash(libelle, description) VALUES('$libelle', '$description')";

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