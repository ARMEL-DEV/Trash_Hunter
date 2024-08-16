<?php
    require_once '../../connectionDB.php';

    $login = $_POST['login'];
    $password = $_POST['password'];
    $query = "SELECT * FROM account a, personne p WHERE a.login='$login' AND a.password=SHA1(MD5('$password')) AND a.idPersonne=p.idPersonne";

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