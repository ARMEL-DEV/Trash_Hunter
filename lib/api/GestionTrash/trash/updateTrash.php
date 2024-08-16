<?php
    require_once '../../connectionDB.php';

    $idTrash = $_POST['idTrash'];
    $idType = $_POST['idType'];
    $idPersonne = $_POST['idPersonne'];
    $gender = $_POST['gender'];
    $image = $_POST['image'];
    $dateEnregistrement = $_POST['dateEnregistrement'];

    $query = "UPDATE trash SET
            idType='$idType',
            idPersonne='$idPersonne',
            gender='$gender',
            image='$image',
            dateEnregistrement='$dateEnregistrement'
            WHERE idTrash='$idTrash'";

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