<?php
    require_once '../../connectionDB.php';

    $adresse = $_POST['adresse'];

    $query = "SELECT * FROM trash t, personne p WHERE t.idPersonne=p.idPersonne AND p.adresse LIKE '%$adresse%' AND t.statut='EN COURS'";

    try{
        $req = connexionPDO()->prepare($query);
        $req->execute();
    }
    catch(PDOException $e){
        print "Erreur de connexion PDO";
        die();
    }

    $result = array();
    $result = $req->fetchAll();
    if (empty($result)) {
        $result="false";
    }
    echo ($result) ?
    json_encode(array("code" => 1, "result" => $result)) :
    json_encode(array("code" => 0, "message" => "Aucune valeur trouvée !"));
?>