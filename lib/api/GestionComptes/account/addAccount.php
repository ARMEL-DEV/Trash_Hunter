<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $idApp = $_POST['idApp'];
    $login = $_POST['login'];
    $password = $_POST['password'];
    $niveauAcces = $_POST['niveauAcces'];

    $query = "INSERT INTO account(idPersonne, idApp, login, password, niveauAcces) VALUES('$idPersonne', '$idApp', '$login', SHA1(MD5('$password')), '$niveauAcces')";

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