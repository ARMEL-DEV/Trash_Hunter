<?php
    require_once '../../connectionDB.php';

    $idPersonne = $_POST['idPersonne'];
    $avatar = $_POST['name'];
    $image = $_FILES["image"]["name"];
    $target_dir = "../../../images/profil/".$avatar;
    move_uploaded_file($_FILES["image"]["tmp_name"], $target_dir);

    $query = "UPDATE personne SET
            profil='$avatar'
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