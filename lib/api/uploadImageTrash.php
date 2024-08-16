
<?php
    require_once '../../connectionDB.php';
    //$avatar = $_POST['name'];
    //$image = $_FILES["image"]["name"];
    //$target_dir = "../../../images/ordures/".$avatar;
    //move_uploaded_file($_FILES["image"]["tmp_name"], $target_dir);

    $uploadTo = "../../../images/ordures/";
    $allowImageExt = array('jpg','png','jpeg','gif');
    $imageName = $_FILES['image']['name'];
    $tempPath=$_FILES["image"]["tmp_name"];
    $imageQuality= 20;
    $basename = basename($imageName);
    $originalPath = $uploadTo.$basename;
    $imageExt = pathinfo($originalPath, PATHINFO_EXTENSION);
    $compressedImage = compress_image($tempPath, $originalPath, $imageQuality);

    function compress_image($tempPath, $originalPath, $imageQuality){
        // Get image info
        $imgInfo = getimagesize($tempPath);
        $mime = $imgInfo['mime'];

        // Create a new image from file
        switch($mime){
            case 'image/jpeg':
                $image = imagecreatefromjpeg($tempPath);
                break;
            case 'image/png':
                $image = imagecreatefrompng($tempPath);
                break;
            case 'image/gif':
                $image = imagecreatefromgif($tempPath);
                break;
            default:
                $image = imagecreatefromjpeg($tempPath);
        }

        // Save image
        imagejpeg($image, $originalPath, $quality);
        // Return compressed image
        return $originalPath;
    }
?>