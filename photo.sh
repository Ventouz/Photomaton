#!/bin/bash

###################################################
### VARIABLES
###################################################

  date=$(date +"%y-%m-%d_%H-%M-%S")
  res1=$(date +%s.%N)

#### Couleurs
  White='\e[1;37m'
  Blue='\e[0;34m'
  Green='\e[0;32m'
  Cyan='\e[0;36m'
  Red='\e[0;31m'
  Purple='\e[0;35m'
  Yellow='\e[1;33m'
  Grey='\e[0;30m'
  NC='\e[39m'

#### Chemins
  RACINE='/var/www/html'                  # Chemin racine du script et web
  IMG_WEB='/var/www/html/img/bg-img'      # Chemin pour images site web
  IMG_RESET='/var/www/html/img/reset'     # Images de remise à zéro
  LOG='/var/www/html/photomaton.log'      # Fichier log pour debug
  CAPTURE='/var/www/html/capture'         # Répertoire de capture photo
  PHOTOS='/var/www/html/photos'           # Répertoire pour envoie gdrive
  WATERMARKED='/var/www/html/watermarked' # Répertoire pour images avec logo
  IMG_TMP='/var/www/html/tmp'             # Répertoire pour optimisation


  whoami=$(whoami)

###################################################
### UTILITAIRES et DIVERS
###################################################
# Fonctions utilitaires pour debug et
# analyse de logs

photomaton_timings()
{
  res2=$(date +%s.%N)
  dt=$(echo "$res2 - $res1" | bc)
  dd=$(echo "$dt/86400" | bc)
  dt2=$(echo "$dt-86400*$dd" | bc)
  dh=$(echo "$dt2/3600" | bc)
  dt3=$(echo "$dt2-3600*$dh" | bc)
  dm=$(echo "$dt3/60" | bc)
  ds=$(echo "$dt3-60*$dm" | bc)

  printf "Temps écoulé: %02.4f s \n" $ds

}

photomaton_start(){
  echo -e "${Green}--------------------------------------------------------------------------------${NC}"
  echo -e "${Green}------------------------   DEBUT  DU  SCRIPT  ----------------------------------${NC}"
  echo -e "${Green}--------------------------------------------------------------------------------${NC}"
  photomaton_timings

}

photomaton_end(){


  photomaton_timings
  echo -e "${Red}--------------------------------------------------------------------------------${NC}"
  echo -e "${Red}--------------------------   FIN   DU   SCRIPT  --------------------------------${NC}"
  echo -e "${Red}--------------------------------------------------------------------------------${NC}"

}

###################################################
### PURGE DU DOSSIER PHOTOS
###################################################
# Supprimer toutes les photos dans le dossier photo
# pour qu'il n'y ait qu'une seule photo lors de
# l'éxécution des autres fonctions

photomaton_purge()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Yellow} Purge des photos !${NC}"

  rm -v $CAPTURE/*.jpg

  cd $PHOTOS
  rm -vf $(ls -1t . | tail -n +5)

photomaton_timings
}


###################################################
### EFFECTUER CAPTURE
###################################################
# Utiliser le programme gphoto2 pour prendre une photo
# et transférer l'image dans le dossier $WEB/photos.
# Le nom de l'image comporte la date de capture.

photomaton_capture()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Capture de la photo ... ${NC}"

  cd $CAPTURE
  sudo -u root sh -c "gphoto2 --capture-image-and-download --filename=image_%Y-%m-%d_%H-%M-%S.jpg"

  if [[ $? -ne 0 ]]; then
    echo -e "${Red} Erreur de capture. ${NC}"
#    exit 1
  fi

  photomaton_timings
}

###################################################
### RENOMMER POUR AJOUT WATERMARK
###################################################
photomaton_watermark()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Ajout du logo Efficom ${NC}"

  cp -v $CAPTURE/*.jpg $WATERMARKED
  cd -v $WATERMARKED
  mv -v *.jpg capture0000.jpg

  sleep 4

  mv -v capture0000.jpg $PHOTOS/image_$date.jpg

  photomaton_timings
}

###################################################
### COPIE SUR CLE USB
###################################################
photomaton_usb()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Copie sur /media/usb${NC}"

  if [ ! -d "/media/usb/photos" ]; then
    echo -e "${Yellow} Création dossier photos sur clé USB... ${NC}"
    mkdir /media/usb/photos/
  fi

  sudo -u root cp -v $PHOTOS/*.jpg /media/usb/photos

  photomaton_timings
}

###################################################
### ENVOYER PHOTOS SUR CLOUD
###################################################
photomaton_cloud()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Transfert des photos sur Google Drive ...${NC}"

  cd $RACINE
  cp -v $CAPTURE/*.jpg $PHOTOS/
  sudo -u www-data sh -c "cd /var/www/html && gdrive sync upload photos 1NjbbyfiUYrF7x2yPxk7HbgdEqAqZFvhw"
  echo -e "${Cyan} Lien : ${Blue} https://drive.google.com/open?id=1NjbbyfiUYrF7x2yPxk7HbgdEqAqZFvhw ${NC}"

  photomaton_timings
}


###################################################
### OPTIMISER
###################################################
# Purge dossier tmp
# Copie images haute qualité pour traitement dans tmp
# Optimisation des images par compression jpg

photomaton_optim()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Optimisation des photos JPEG ...${NC}"

  rm -v $IMG_TMP/*.jpg
  cp -v $CAPTURE/*.jpg $IMG_TMP
  cd -v $IMG_TMP
  jpegoptim -m40 --strip-all *.jpg

  photomaton_timings
}


###################################################
### AFFICHAGE DES PHOTOS LES PLUS RECENTES
###################################################
# Copie les images optimisées dans le dossier d'affichage

photomaton_web()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Déplacement des photos pour affichage ...${NC}"

  mv -v $IMG_TMP/*.jpg $IMG_WEB

  photomaton_timings
}

###################################################
### ROTATIONS
###################################################
# Supprimer les fichiers les plus anciens en ignorant les 4 plus récents
# La photo la plus ancienne est supprimée
# Il ne reste que les 3 plus récentes et la photo qui vient d'être prise
# Renommer les images en 5-9.jpg pour éviter les conflits
# Renommer les images en 1-4.jpg pour être affichés sur le site web

photomaton_rotate()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Suppression de la plus ancienne photo ...${NC}"

  cd $IMG_WEB
  rm -f $(ls -1t . | tail -n +5)

  mv -v 3.jpg 4.jpg
  mv -v 2.jpg 3.jpg
  mv -v 1.jpg 2.jpg
  mv -v image_*.jpg 1.jpg

  # a=5
  # for i in *.jpg; do
  #   mv "$i" "$a".jpg
  #   let a=a+1
  # done
  #
  # a=1
  # for i in *.jpg; do
  #   mv "$i" "$a".jpg
  #   let a=a+1
  # done

  photomaton_timings
}


######################################################################################################
######################################################################################################
#####                                                                                            #####
#####         LE SCRIPT PRINCIPAL COMMENCE ICI                                                   #####
#####                                                                                            #####
######################################################################################################
######################################################################################################

photomaton_start >> $RACINE/photomaton.log
photomaton_timings >> $RACINE/photomaton.log

## Phase de capture de photo avec gphoto2
photomaton_purge >> $RACINE/photomaton.log
photomaton_capture >> $RACINE/photomaton.log

## Ajout du logo Efficom par php
# photomaton_watermark >> $RACINE/photomaton.log # Fonction désactivée, géré par php

## Optimisation et affichage avec jpegoptim et site web
photomaton_optim >> $RACINE/photomaton.log
photomaton_web >> $RACINE/photomaton.log
photomaton_rotate >> $RACINE/photomaton.log

## Stockage des photos sur clé USB et sur Google Drive avec gdrive
photomaton_usb >> $RACINE/photomaton.log
photomaton_cloud >> $RACINE/photomaton.log
photomaton_purge >> $RACINE/photomaton.log

photomaton_end >> $RACINE/photomaton.log
