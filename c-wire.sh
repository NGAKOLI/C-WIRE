#!/bin/bash

echo " cheminfichier: $1"
cheminfichier="$1"
station="$2"
consumer="$3"
id_centrale="$4"



affiche_aide(){
  echo " "
  echo " Rentrer : c-wire.sh <chemindufichier> <type_station> <type_consommateur>  "
  echo " "
  echo " <type_station>    type de station : hvb, hva ou lv " 
  echo " <type_consommateur> type de consommateur : comp, indiv ou all  " 
  echo " si <type_station> = hvb alors type de consommateur = comp " 
  echo " si <type_station> = hva alors type de consommateur = comp "
  echo " "
  echo " Options : " 
  echo " "
  echo " -h     Affiche cette aide "
  echo " "
  echo " Si vous souhaitez identification centrale spécifique taper 1 sinon entrer une autre valeur" 
  echo " Rentrer valeur de la centrale entre 1 à 5 "

  exit 1

}

if [[ "$*" == *"-h"* ]] || [[ $# -lt 3 ]]; then  # affiche option d'aide si '-h' selectionné ou s'il y a une erreur trop d'arguments
    echo " " 
    echo " Erreur : nombre d'arguments incorrect "  
    affiche_aide
    
fi

verification=0

if [[ "$cheminfichier" != *.dat ]]; then
  echo “ Erreur : le fichier spécifié n’est pas un fichier .dat “
  verification=1
  affiche_aide
fi

if [ -d "./tmp" ]; then # verifie la présence dossier tmp
  rm -rf ./tmp/*       # supprime contenu dossier s'il exite

else 
  mkdir ./tmp          # si dossier n'existe pas le créer

fi

debut=$(date +%s)



if [ "$station" != hvb ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then
  echo " Erreur saisie incorrect : entrer 'hvb', 'hva' ou 'lv' "
  affiche_aide
  exit 1 
  
fi

if [ "$station" == "hvb" ] && [[ "$consumer" == "all" || "$consumer" == "indiv" || "$consumer" != "comp" ]]; then
 echo "Erreur saisie incorrect : entrer 'comp' "
 affiche_aide
  exit 2
  
elif [ "$station" == "hva" ] && [[ "$consumer" == "all" || "$consumer" == "indiv" || "$consumer" != "comp" ]]; then
  echo "  Erreur saisie incorrect : entrer 'comp' "
  affiche_aide
  exit 3
elif [ "$station" == "lv" ] && [[ "$consumer" != "all" && "$consumer" != "indiv" && "$consumer" != "comp" ]]; then
 echo "Erreur saisie incorrect : entrer 'all','indiv','comp' "
 affiche_aide
  exit 4
  
fi

fin=$(date +%s)

echo "Souhaitez-vous sélectionner une centrale spécifique ? Oui = 1 "
read choix


if [[ "$choix" == "1" ]]; then
  echo "Veuillez entrer l'identifiant de la centrale (1-5) :"
  read id_centrale
  debut2=$(date +%s)
  if ! [[ "$id_centrale" =~ ^[1-5]$ ]]; then
    echo "Erreur : identifiant incorrect"
    affiche_aide
    exit 5
    
  fi

    fichier_final="/workspaces/C-WIRE/tests/${station}_${consumer}_${id_centrale}.csv"
    fichier_tmp="/workspaces/C-WIRE/tmp/${station}_${consumer}_${id_centrale}_tmp.csv"
    echo " Station_${station}:Capacite:Consommation_${consumer}" >> ./tests/${station}_${consumer}_${id_centrale}.csv
  
  if [ "$station" == "hvb" ] && [ "$consumer" == "comp" ]; then
    grep -E "^$id_centrale+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 2,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    
  elif [ "$station" == "hva" ] && [ "$consumer" == "comp" ]; then
    grep -E "^$id_centrale+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-"  "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    grep -E "^$id_centrale+;-;[0-9]+;-;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
   
  elif [ "$station" == "lv" ]; then
    if [ "$consumer" == "comp" ]; then
     grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
     grep -E "^$id_centrale+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':'>> "$fichier_tmp"
  
    elif [ "$consumer" == "indiv" ]; then
      grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
    
    elif [ "$consumer" == "all" ]; then
      grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      
    fi
fi


else 
  debut2autre=$(date +%s)

  fichier_final="/workspaces/C-WIRE/tests/${station}_${consumer}.csv"
  fichier_tmp="/workspaces/C-WIRE/tmp/${station}_${consumer}_tmp.csv"
  echo " Station_${station}:Capacite:Consommation_${consumer}" >> ./tests/${station}_${consumer}.csv
  echo "Traitement effectué sur toutes les centrales du fichier " 
  
  if [ "$station" == "hvb" ] && [ "$consumer" == "comp" ]; then
    grep -E "^[0-9]+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 2,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
 
  elif [ "$station" == "hva" ] && [ "$consumer" == "comp" ]; then
    grep -E "^[0-9]+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-"  "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    grep -E "^[0-9]+;-;[0-9]+;-;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
   
  elif [ "$station" == "lv" ]; then
    if [ "$consumer" == "comp" ]; then
     grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
     grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"

    elif [ "$consumer" == "indiv" ]; then
      grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    
    elif [ "$consumer" == "all" ]; then
      grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':'>> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
    
    fi
  fi
fi


# Compilation du programme C
make -C /workspaces/C-WIRE/codeC

# Exécution du programme C avec les fichiers temporaires et finaux
/workspaces/C-WIRE/codeC/main "$fichier_tmp" "$fichier_final"
if [[ "$station" == "lv" && "$consumer" == "all" ]]; then
  fichier_minmax="/workspaces/C-WIRE/tests/lv_all_minmax.csv"
  sort -t ':' -k3 -nr "$fichier_final" |tail -n +1 | head -n 10 > "$fichier_minmax"
  sort -t ':' -k3 -n "$fichier_final" |tail -n +2 | head -n 10 >> "$fichier_minmax"
  
  echo "Fichier lv_all_minmax.csv généré avec succès."

fi


fin2=$(date +%s)

if [[ "$choix" == "1" ]]; then
  debuttmp=$debut2
else
  debuttmp=$debut2autre
fi

duree=$(( fin2 - debuttmp ))
duree2=$(( fin - debut ))
echo "Durée traitement : $(($duree+$duree2)) secondes"