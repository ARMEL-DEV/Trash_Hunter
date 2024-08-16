<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $nom = $_POST['nom'];
    $prenom = $_POST['prenom'];
    $sexe = $_POST['sexe'];
    $email = $_POST['email'];
    $contact = $_POST['contact'];
    $adresse = $_POST['adresse'];

    $query = "UPDATE personne SET
            nom='$nom',
            prenom='$prenom',
            sexe='$sexe',
            email='$email',
            contact='$contact',
            adresse='$adresse'
            WHERE idPersonne='$idPersonne'";

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