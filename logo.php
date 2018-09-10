<?php
sleep(3);
// Variables inchangées
$stamp = imagecreatefromjpeg('img/logo.jpg');

// Définit les marges pour le cachet et récupère la hauteur et la largeur de celui-ci
$marge_right = 10;
$marge_bottom = 10;
$sx = imagesx($stamp);
$sy = imagesy($stamp);

for ($i = 1; $i <= 4; $i++){
    $im = imagecreatefromjpeg('img/bg-img/'.$i.'.jpg');
    imagecopy($im, $stamp, imagesx($im) - $sx - $marge_right, imagesy($im) - $sy - $marge_bottom, 0, 0, imagesx($stamp), imagesy($stamp));
    header('Content-type: image/jpeg');
    imagejpeg($im, 'img/bg-img/'.$i.'.jpg');
    imagedestroy($im);
}
?>
