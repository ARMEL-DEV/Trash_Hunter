<?php
    require_once '../connectionDB.php';

    $query = "SELECT * FROM application";

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