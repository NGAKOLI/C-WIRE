#!/bin/bash

echo "Chemin du fichier:$1"
station="$2"
consumer="$3"
powerplant="$4"

affiche_aide(){
  echo " Rentrer : c-wire.sh  <type_station> <type_consommateur> <id_centrale> "
  echo " "
  echo " Options : " 
  echo " -h     Affiche cette aide " 
  echo " <type_station>    Type de station : hvb, hva ou lv " 
  echo " <type_consommateur> Type de consommateur : comp, indiv, all  " 
  echo " si <type_station> = hvb alors Type de consommateur = comp " 
  echo " si <type_station> = hva alors Type de consommateur = comp "
  echo " <id_centrale>  Optionnel identification d'une centrale en particulier entre 1 à 5" 

  exit 1

}

if [[ "$*" == *"-h"* ]] || [[ $# -lt 3 ]]; then  # affiche option d'aide si '-h' selectionné ou s'il y a une erreur trop d'arguments
    affiche_aide
fi

if [ "$station" != hvb ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then
  echo " Erreur saisie incorrect : entrer hvb,hva ou lv"
  affiche_aide
    exit 1 
fi
if [ "$station" == "hvb" ] && [[ "$consumer" == "all" || "$consumer" == "indiv" || "$consumer" != "comp" ]]; then
 echo "Erreur saisie incorrect : entrer  'comp' "
 affiche_aide
    exit 2
elif [ "$station" == "hva" ] && [[ "$consumer" == "all" || "$consumer" == "indiv" || "$consumer" != "comp" ]]; then
  echo "  Erreur saisie incorrect : entrer  comp' "
    exit 3
elif [ "$station" == "lv" ] && [[ "$consumer" != "all" && "$consumer" != "indiv" && "$consumer" != "comp" ]]; then
 echo "Erreur saisie incorrect : entrer 'all','indiv','comp' "
    exit 4
fi

if [ -d "./tmp" ]; then # verifie la présence dossier tmp
  rm -rf ./tmp/*       # supprime contenu dossier s'il exite

else 
  mkdir ./tmp          # si dossier n'existe pas le créer

fi

if [ "$station" == "hvb" ]; then
    echo "Power plant;HVB-Station;HVA-Station;LV Station;Company;Individual;Capacity;Load" > ./tmp/hvb.csv
    grep -E "^[0-9]+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat"  >> ./tmp/hvb.csv

elif [ "$station" == "hva" ]; then
  echo "Power plant;HVB-Station;HVA-Station;LV Station;Company;Individual;Capacity;Load" > ./tmp/hva.csv
  grep -E "^[0-9]+;[0-9]+;[0-9]+;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" >> ./tmp/hva.csv
  grep -E "^[0-9]+;-;[0-9]+;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" >> ./tmp/hva.csv
elif [ "$station" == "lv" ];then
  echo "Power plant;HVB-Station;HVA-Station;LV Station;Company;Individual;Capacity;Load" > ./tmp/lv_comp.csv
  grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+" "/workspaces/C-WIRE/input/c-wire_v00.dat" >> ./tmp/lv_comp.csv
  echo "Power plant;HVB-Station;HVA-Station;LV Station;Company;Individual;Capacity;Load" > ./tmp/lv_indiv.csv
  grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+" "/workspaces/C-WIRE/input/c-wire_v00.dat" >> ./tmp/lv_indiv.csv
fi

echo "Souhaitez-vous sélectionner une centrale spécifique ? Oui = 1"
read choix

if [[ "$choix" == "1" ]]; then
  echo "Veuillez entrer l'identifiant de la centrale (1-5) :"
  read id_centrale

  if ! [[ "$id_centrale" =~ ^[1-5]$ ]]; then
    echo "Erreur : identifiant incorrect"
    affiche_aide
    exit 5
  fi
  echo "Racine station;Identifiant;Capacity;Load" > ./tmp/filtren.csv
  grep -E "^[0-9]+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | grep "^$id_centrale;" | cut -d ';' -f 1,2,7,8 | tr '-' '0' >> ./tmp/filtren.csv
  grep -E "^[0-9]+;[0-9]+;[0-9]+;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | grep "^$id_centrale;" | cut -d ';' -f 2,3,7,8 | tr '-' '0'>> ./tmp/filtren.csv
  grep -E "^[0-9]+;-;[0-9]+;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | grep "^$id_centrale;" | cut -d ';' -f 3,5,7,8 | tr '-' '0' >> ./tmp/filtren.csv
  grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+" "/workspaces/C-WIRE/input/c-wire_v00.dat" | grep "^$id_centrale;" | cut -d ';' -f 4,5,7,8 | tr '-' '0'>> ./tmp/filtren.csv
  grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+" "/workspaces/C-WIRE/input/c-wire_v00.dat" | grep "^$id_centrale;" | cut -d ';' -f 4,6,7,8 | tr '-' '0' >> ./tmp/filtren.csv


else 
  
  echo "Traitements  effectués sur toutes les centrales du fichier " 
  echo "Racine station;Identifiant;Capacity;Load" > ./tmp/filtren.csv
  grep -E "^[0-9]+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 1,2,7,8 | tr '-' '0' >> ./tmp/filtren.csv
  grep -E "^[0-9]+;[0-9]+;[0-9]+;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 2,3,7,8 | tr '-' '0'>> ./tmp/filtren.csv
  grep -E "^[0-9]+;-;[0-9]+;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,5,7,8 | tr '-' '0' >> ./tmp/filtren.csv
  grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,5,7,8 | tr '-' '0'>> ./tmp/filtren.csv
  grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,6,7,8 | tr '-' '0' >> ./tmp/filtren.csv

fi
