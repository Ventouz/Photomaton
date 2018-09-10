#!/bin/bash

###################################################
### VARIABLES
###################################################

  date=$(date +"%y-%m-%d   %H:%M:%S")

# Couleurs
  White='\e[1;37m'
  Blue='\e[0;34m'
  Green='\e[0;32m'
  Cyan='\e[0;36m'
  Red='\e[0;31m'
  Purple='\e[0;35m'
  Yellow='\e[1;33m'
  Grey='\e[0;30m'
  NC='\e[39m'

# Chemins
  RACINE='/var/www/html'
  LOG='/var/www/html/photomaton.log'

  whoami=$(whoami)

#### Chemins
  RACINE='/var/www/html'                  # Chemin racine du script et web
  IMG_WEB='/var/www/html/img/bg-img'      # Chemin pour images site web
  IMG_RESET='/var/www/html/img/reset'     # Images de remise à zéro
  LOG='/var/www/html/photomaton.log'      # Fichier log pour debug
  CAPTURE='/var/www/html/capture'         # Répertoire de capture photo
  PHOTOS='/var/www/html/photos'           # Répertoire pour envoie gdrive
  WATERMARKED='/var/www/html/watermarked' # Répertoire pour images avec logo
  IMG_TMP='/var/www/html/tmp'             # Répertoire pour optimisation


###################################################
### APPLICATION IMAGES PAR DEFAUT
###################################################
# Supprime les images actuellement affichées, et
# les remplace par des images de base stockées
# dans le dossier reset

photomaton_reset()
{
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"
  echo -e "${Cyan} Réinitialisation de la vitrine ...${NC}"
  echo -e "${Purple}++++++++++++++++++++++++++++++++++++++++${NC}"

  rm -v $IMG_WEB/*.jpg
  cp -v $IMG_RESET/*.jpg $IMG_WEB

  echo -e "${Blue} Vitrine réinitialisée ! ${NC}"
}


######################################################################################################
######################################################################################################
#####                                                                                            #####
#####         LE SCRIPT PRINCIPAL COMMENCE ICI                                                   #####
#####                                                                                            #####
######################################################################################################
######################################################################################################

photomaton_reset >> $RACINE/photomaton.log
