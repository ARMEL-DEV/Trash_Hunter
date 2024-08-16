<?php
    require_once '../../connectionDB.php';

    $idType = $_POST['idType'];
    $libelle = $_POST['libelle'];
    $description = $_POST['description'];

    $query = "UPDATE typetrash SET libelle='$libelle', description='$description' WHERE idType='$idType'";

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