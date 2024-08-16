<?php
    require_once '../connectionDB.php';

    $idNew = $_POST['idNew'];
    $idPersonne = $_POST['idPersonne'];
    $libelle = $_POST['libelle'];
    $description = $_POST['description'];
    $time = $_POST['time'];
    $image = $_POST['image'];

    $query = "UPDATE news SET
            libelle='$libelle',
            description='$description',
            time='$time',
            image='$image'
            WHERE idNew='$idNew' AND idPersonne='$idPersonne'";

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