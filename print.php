<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta http-equiv="pragma" content="no-cache" />
        <meta charset="UTF-8">
        <meta name="description" content="">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <title>Page d'impression</title>
        <!-- Core Style CSS -->
        <link rel="stylesheet" href="css/core-style.css">
        <link rel="stylesheet" href="style.css">

        <!-- Responsive CSS -->
        <link href="css/responsive.css" rel="stylesheet">
        
        <!-- Favicon  -->
        <link rel="icon" href="img/core-img/favicon.ico">
        
    </head>
    <body style="background-color: rgba(0, 0, 0, 0.17);">
        <a href="index.php"><img src="img/icons/photo.png" class="icon"></a>
        <h1 id="album">Album photo à imprimer</h1>
        <div id="line"></div>

        <?php
        // Insère dans une variable tous les fichiers .jpg du dossier bg-img
        $files = glob('img/bg-img/*.jpg');
        echo "<div id='printphotos'>";
        foreach($files as $filename){ // Affiche chaque photo dans une balise img
            echo "<img src='".$filename."' class='printphoto'>";
        }
        echo "</div>";
        ?>

    </body>
</html>