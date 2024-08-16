<?php
    require_once '../../connectionDB.php';
          
    $nom = $_POST['nom'];
    $prenom = $_POST['prenom'];
    $contact = $_POST['contact'];
    $adresse = $_POST['adresse'];

    $query_insert = "INSERT INTO personne(nom, prenom, adresse, contact) VALUES('$nom', '$prenom', '$adresse', '$contact')";

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