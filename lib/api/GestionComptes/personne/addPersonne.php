<?php
    require_once '../../connectionDB.php';
          
    $nom = $_POST['nom'];
    $prenom = $_POST['prenom'];
    $sexe = $_POST['sexe'];
    $email = $_POST['email'];
    $contact = $_POST['contact'];
    $adresse = $_POST['adresse'];
    $profil = $_POST['profil'];

    $query_insert = "INSERT INTO personne(nom, prenom, sexe, adresse, contact, email, profil) VALUES('$nom', '$prenom', '$sexe', '$adresse', '$contact', '$email', '$profil')";

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