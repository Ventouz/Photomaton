<!DOCTYPE html>
<html lang="fr">

    <head>
        <meta http-equiv="pragma" content="no-cache" />
        <meta charset="UTF-8">
        <meta name="description" content="">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <!-- Title  -->
        <title>Photobooth | Prise de photos en direct</title>

        <!-- Favicon  -->
        <link rel="icon" href="img/core-img/favicon.ico">

        <!-- Core Style CSS -->
        <link rel="stylesheet" href="css/core-style.css">
        <link rel="stylesheet" href="style.css">

        <!-- Responsive CSS -->
        <link href="css/responsive.css" rel="stylesheet">

        <!-- jQuery (Necessary for All JavaScript Plugins) -->
        <script src="js/jquery/jquery-2.2.4.min.js"></script>

        <script>
            // Déclaration de variables
            var compteur = 0;
            var cpt = 3 ;
            var x ;
            var nbphotos = 0;
            var xx = 0;

            // Fonction decompte : prise de la photo
            function decompte()
            {
                if (cpt == 0){
                    $("#loadphoto").load("page.php"); // Charge la page servant à exécuter le script de la prise de la photo (photo.sh)
                    document.getElementById("chrono").innerHTML = "Votre photo est prise";

                    nbphotos += 1;
                    if (nbphotos == 1){ // Change la 1ère photo si c'est le premier clic et initialise les 3 autres photos avec les photos de base
                        document.getElementById("photo1").style.backgroundImage="url(img/bg-img/1.jpg)";
                        document.getElementById("photoMin1").style.backgroundImage="url(img/bg-img/1.jpg)";
                        // document.getElementById("photo2").style.backgroundImage="url(img/reset/2.jpg)";
                        // document.getElementById("photoMin2").style.backgroundImage="url(img/reset/2.jpg)";
                        // document.getElementById("photo3").style.backgroundImage="url(img/reset/3.jpg)";
                        // document.getElementById("photoMin3").style.backgroundImage="url(img/reset/3.jpg)";
                        // document.getElementById("photo4").style.backgroundImage="url(img/reset/4.jpg)";
                        // document.getElementById("photoMin4").style.backgroundImage="url(img/reset/4.jpg)";
                    } else if (nbphotos == 2){ // Change la 2ème photo si c'est le deuxième clic
                        document.getElementById("photo2").style.backgroundImage="url(img/bg-img/2.jpg)";
                        document.getElementById("photoMin2").style.backgroundImage="url(img/bg-img/2.jpg)";
                    } else if (nbphotos == 3){ // Change la 3ème photo si c'est le troisième clic
                        document.getElementById("photo3").style.backgroundImage="url(img/bg-img/3.jpg)";
                        document.getElementById("photoMin3").style.backgroundImage="url(img/bg-img/3.jpg)";
                    } else if (nbphotos == 4){ // Change la 4ème photo si c'est le quatrième clic et remet la variable à 0 (recommencer les photos)
                        document.getElementById("photo4").style.backgroundImage="url(img/bg-img/4.jpg)";
                        document.getElementById("photoMin4").style.backgroundImage="url(img/bg-img/4.jpg)";
                        nbphotos = 0;
                    }

                    cpt--; // cpt négatif => passage dans le else
                    setTimeout("decompte()", 5000); // Attend 5 secondes pour ré-effectuer la fonction
                }
                else if(cpt>=0) // Décompte de 3 à 0
                {
                    document.getElementById("addphoto").style.display="none";
                    if (cpt == 1){
                        document.getElementById("chrono").innerHTML = "Souriez, photo dans " + cpt + " seconde ..." ;
                    }
                    else
                    {
                        document.getElementById("chrono").innerHTML = "Souriez, photo dans " + cpt + " secondes ..." ;
                    }
                    cpt-- ;
                    x = setTimeout("decompte()",1000); // Attend 1 seconde pour ré-effectuer la fonction
                }
                else
                {
                    $("#loadphoto").load("logo.php");
                    cpt = 3;
                    document.getElementById("chrono").innerHTML = "";
                    document.getElementById("addphoto").style.display="block";
                    x = setTimeout("decompte()",1000); // Attend 1 seconde pour ré-effectuer la fonction
                    document.location.reload("index.php"); // Rafraichit la page
                }

            }

            function resetphoto(){
                if(xx == 0){
                    $("#resetphoto").load("reset.php");
                    document.getElementById("chrono").innerHTML = "Réinitialisation des photos ..." ;
                    xx++;
                    x = setTimeout("resetphoto()",1000); // Attend 5 secondes pour ré-effectuer la fonction
                } else {
                    document.getElementById("chrono").innerHTML = "" ;
                    xx = 0;
                    document.location.reload("index.php"); // Rafraichit la page
                }
            }


        </script>
    </head>

    <body>
        <!-- ***** Welcome Area Start ***** -->
        <section class="welcome-area">
            <div class="carousel h-100 slide" data-ride="" id="welcomeSlider">
                <!-- Carousel Inner -->
                <div>
                    <a href="#" onclick="decompte()" id="addphoto"><img src="img/icons/photo.png" class="bouton"></a>
                    <div id="loadphoto" style="display:none;"></div>
                    <p id="chrono"></p>
                </div>
                <div>
                    <a href="#" onclick="resetphoto()" id="refreshphoto"><img src="img/icons/reset.png" class="icon" id="reset"></a>
                    <a href="print.php" id=""><img src="img/icons/print.png" class="icon" id="print"></a>
                    <div id="resetphoto"></div>
                </div>

                <script>

                </script>


                <div class="carousel-inner h-100" id="photos">
                    <div class="carousel-item img h-100 bg-img active" id="photo1" style="background-image: url(img/bg-img/1.jpg);"></div>
                    <div class="carousel-item img h-100 bg-img" id="photo2" style="background-image: url(img/bg-img/2.jpg);"></div>
                    <div class="carousel-item img h-100 bg-img" id="photo3" style="background-image: url(img/bg-img/3.jpg);"></div>
                    <div class="carousel-item img h-100 bg-img" id="photo4" style="background-image: url(img/bg-img/4.jpg);"></div>
                </div>
                <!-- Carousel Indicators -->
                <ol class="carousel-indicators" id="photosMin">
                    <li data-target="#welcomeSlider" data-slide-to="0" class="active bg-img" id="photoMin1" style="background-image: url(img/bg-img/1.jpg);"></li>
                    <li data-target="#welcomeSlider" data-slide-to="1" class="bg-img" id="photoMin2" style="background-image: url(img/bg-img/2.jpg);"></li>
                    <li data-target="#welcomeSlider" data-slide-to="2" class="bg-img" id="photoMin3" style="background-image: url(img/bg-img/3.jpg);"></li>
                    <li data-target="#welcomeSlider" data-slide-to="3" class="bg-img" id="photoMin4" style="background-image: url(img/bg-img/4.jpg);"></li>
                </ol>
            </div>
        </section>


        <!-- Popper js -->
        <script src="js/popper.min.js"></script>
        <!-- Bootstrap js -->
        <script src="js/bootstrap.min.js"></script>
        <!-- Plugins js -->
        <script src="js/plugins.js"></script>
        <!-- Active js -->
        <!--<script src="js/active.js"></script>-->

    </body>

</html>
