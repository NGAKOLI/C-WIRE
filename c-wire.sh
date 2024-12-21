#!/bin/bash

echo " cheminfichier: $1"
cheminfichier="$1"
station="$2"
consommateur="$3"
id_centrale="$4"


if [ -d "./tmp" ]; then # verifie la présence dossier tmp
  rm -rf ./tmp/*       # supprime contenu dossier s'il exite

else 
  mkdir ./tmp          # si dossier n'existe pas le créer

fi

debut=$(date +%s)

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
  echo " Puis rentrer valeur de la centrale entre 1 à 5 "
  echo " "
  fin=$(date +%s)
  duree=$(( fin - debut ))
  echo " Durée traitement : $duree secondes"

  exit 1

}


if [[ "$*" == *"-h"* ]] || [[ $# -lt 3 ]]; then  # affiche option d'aide si '-h' selectionné ou s'il y a une erreur trop d'arguments
  echo " " 
  echo "  Erreur : nombre d'arguments incorrect "  
  affiche_aide
  exit 1
    
fi

verification=0
if [[ "$cheminfichier" != *.dat ]]; then
  echo " Erreur : le fichier spécifié n’est pas un fichier .dat "
  verification=1
  affiche_aide
  exit 2
fi


if [ "$station" != hvb ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then
  echo " Erreur saisie incorrect : entrer 'hvb', 'hva' ou 'lv' "
  affiche_aide
  exit 3 
  
fi

if [ "$station" == "hvb" ] && [[ "$consommateur" == "all" || "$consommateur" == "indiv" || "$consommateur" != "comp" ]]; then
  echo " Erreur saisie incorrect : entrer 'comp' "
  affiche_aide
  exit 4
  
elif [ "$station" == "hva" ] && [[ "$consommateur" == "all" || "$consommateur" == "indiv" || "$consommateur" != "comp" ]]; then
  echo "  Erreur saisie incorrect : entrer 'comp' "
  affiche_aide
  exit 5
elif [ "$station" == "lv" ] && [[ "$consommateur" != "all" && "$consommateur" != "indiv" && "$consommateur" != "comp" ]]; then
 echo "Erreur saisie incorrect : entrer 'all','indiv','comp' "
 affiche_aide
  exit 6
  
fi

fin1=$(date +%s)

echo "Souhaitez-vous sélectionner une centrale spécifique ? Oui = 1 "
read choix


if [[ "$choix" == "1" ]]; then
  echo "Veuillez entrer l'identifiant de la centrale (1-5) :"
  read id_centrale
  debut2=$(date +%s)
  if ! [[ "$id_centrale" =~ ^[1-5]$ ]]; then
    echo "Erreur : identifiant incorrect"
    affiche_aide
    exit 7
    
  fi

    fichier_final="/workspaces/C-WIRE/tests/${station}_${consommateur}_${id_centrale}.csv"
    fichier_tmp="/workspaces/C-WIRE/tmp/${station}_${consommateur}_${id_centrale}_tmp.csv"
    > "$fichier_final"
    echo " Station_${station}:Capacite:Consommation_${consommateur}" >> ./tests/${station}_${consommateur}_${id_centrale}.csv
  
  if [ "$station" == "hvb" ] && [ "$consommateur" == "comp" ]; then
    grep -E "^$id_centrale+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 2,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    
  elif [ "$station" == "hva" ] && [ "$consommateur" == "comp" ]; then
    grep -E "^$id_centrale+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-"  "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    grep -E "^$id_centrale+;-;[0-9]+;-;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
   
  elif [ "$station" == "lv" ]; then
    if [ "$consommateur" == "comp" ]; then
     grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
     grep -E "^$id_centrale+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':'>> "$fichier_tmp"
  
    elif [ "$consommateur" == "indiv" ]; then
      grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
    
    elif [ "$consommateur" == "all" ]; then
      grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      
    fi
fi


else 
  debut2autre=$(date +%s)

  fichier_final="/workspaces/C-WIRE/tests/${station}_${consommateur}.csv"
  fichier_tmp="/workspaces/C-WIRE/tmp/${station}_${consommateur}_tmp.csv"
  > "$fichier_final"
  echo " Station_${station}:Capacite:Consommation_${consommateur}" >> ./tests/${station}_${consommateur}.csv
  echo "Traitement effectué sur toutes les centrales du fichier " 
  
  if [ "$station" == "hvb" ] && [ "$consommateur" == "comp" ]; then
    grep -E "^[0-9]+;[0-9]+;-;-;" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 2,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
 
  elif [ "$station" == "hva" ] && [ "$consommateur" == "comp" ]; then
    grep -E "^[0-9]+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-"  "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    grep -E "^[0-9]+;-;[0-9]+;-;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
   
  elif [ "$station" == "lv" ]; then
    if [ "$consommateur" == "comp" ]; then
     grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
     grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"

    elif [ "$consommateur" == "indiv" ]; then
      grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    
    elif [ "$consommateur" == "all" ]; then
      grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':'>> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "/workspaces/C-WIRE/input/c-wire_v00.dat" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
    
    fi
  fi
fi


# Compilation du programme C
make -s -C /workspaces/C-WIRE/codeC

# Exécution du programme C avec les fichiers temporaires et finaux
/workspaces/C-WIRE/codeC/main "$fichier_tmp" "$fichier_final"

if [[ "$station" == "lv" && "$consommateur" == "all" ]]; then
  fichier_minmax="/workspaces/C-WIRE/tmp/lv_all_tmp1.csv"
  sort -t ':' -k3 -nr "$fichier_final" |tail -n +1 | head -n 6 > "$fichier_minmax"
  sort -t ':' -k3 -n "$fichier_final" |tail -n +2 | head -n 6 >> "$fichier_minmax"
  fichier_tmp_lv_min_max="/workspaces/C-WIRE/tmp/lv_all_minmax_tmp2.csv"
  fichier_lv_min_max="/workspaces/C-WIRE/tests/lv_all_minmax.csv"
  echo "Min and Max 'capacity-load' extreme nodes " > "$fichier_lv_min_max"
  echo "Station_LV:Capacité:Consommation_all" >> "$fichier_lv_min_max"
  awk -F ':' '{diff = $3 - $2; abs = (diff < 0) ? -diff : diff; print $0, abs}' OFS=':' "$fichier_minmax" > "$fichier_tmp_lv_min_max"
  sort -t ':' -k4 -nr "$fichier_tmp_lv_min_max" | cut -d ':' -f1-3 >> "$fichier_lv_min_max"
 
fi

fin2=$(date +%s)

afficher_duree_execution(){
  if [[ "$choix" == "1" ]]; then
  debuttmp=$debut2
  else
  debuttmp=$debut2autre
  fi
  duree=$(( fin2 - debuttmp ))
  duree2=$(( fin1 - debut ))
  echo "Durée traitement : $(($duree+$duree2)) secondes"
}

afficher_duree_execution

