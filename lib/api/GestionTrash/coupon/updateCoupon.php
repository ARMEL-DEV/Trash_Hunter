<?php
    require_once '../../connectionDB.php';

    $idCoupon = $_POST['idCoupon'];
    $idPersonne = $_POST['idPersonne'];
    $Use_idPersonne = $_POST['Use_idPersonne'];
    $description = $_POST['description'];
    $dateCoupon = $_POST['dateCoupon'];
    $preuve = $_POST['preuve'];

    $query = "UPDATE couponreabonnement SET
            Use_idPersonne='$Use_idPersonne',
            description='$description',
            dateCoupon='$dateCoupon',
            preuve='$preuve'
            WHERE idCoupon='$idCoupon' AND idPersonne='$idPersonne'";

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