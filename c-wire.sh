#!/bin/bash

echo " cheminfichier: $1" # affiche le chemin du fichier passé en paramètre
cheminfichier="$1" # chemin du fichier .dat
station="$2"   # variable type station parametre
consommateur="$3" #  variable type consommateur parametre
id_centrale="$4" # variable identifiant centrale parametre


if [ ! -x "$1" ] && [ -f "$1" ]; then   # verifie si le fichier est executable
  chmod +x "$1"  # sinon rendre  fichier executable
fi

if [ -d "./tmp" ]; then # verifie la présence du dossier tmp
  rm -rf ./tmp/*       # supprime contenu du dossier s'il exite

else 
  mkdir ./tmp          # si dossier n'existe pas le créer

fi

debut=$(date +%s) # enregistre le temps début d'exécuction

affiche_aide(){ # fonction pour afficher l'aide
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
  fin=$(date +%s) # enregistre le temps fin 
  duree=$(( fin - debut )) # calcule la durée d'exécution
  echo " Durée traitement : $duree secondes"  # affiche la durée d'exécution

  exit 1 # sortir du programme
}


if [[ "$*" == *"-h"* ]] || [[ $# -lt 3 ]]; then  # affiche option d'aide si '-h'  est passé en parametre / erreur si trop d'arguments
  echo " " 
  echo "  Erreur : nombre d'arguments incorrect "  
  affiche_aide
  exit 1
fi

verification=0 # variable de verification
if [[ "$cheminfichier" != *.dat ]]; then  # vérification chemin fichier
  echo " Erreur : le fichier spécifié n’est pas un fichier .dat "
  verification=1 # erreur fichier 
  affiche_aide
  exit 2 # sortir du programme
fi


if [ "$station" != hvb ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then # verifie si le type de station passé en paramètre est correct
  affiche_aide 
  exit 3 # sortir du programme
fi

if [ "$station" == "hvb" ] && [[ "$consommateur" == "all" || "$consommateur" == "indiv" || "$consommateur" != "comp" ]]; then # verifie si le type de consommateur passé en paramètre est correct par rapport à station hvb
  echo " Erreur saisie incorrect : entrer 'comp' "
  affiche_aide
  exit 4 # sortir du programme
  
elif [ "$station" == "hva" ] && [[ "$consommateur" == "all" || "$consommateur" == "indiv" || "$consommateur" != "comp" ]]; then # verifie si le type de consommateur passé en paramètre est correct par rapport à  station hva
  echo "  Erreur saisie incorrect : entrer 'comp' "
  affiche_aide
  exit 5
elif [ "$station" == "lv" ] && [[ "$consommateur" != "all" && "$consommateur" != "indiv" && "$consommateur" != "comp" ]]; then # verifie si le type de consommateur passé en paramètre est correct par rapport à station lv
  echo "Erreur saisie incorrect : entrer 'all','indiv','comp' "
  affiche_aide
  exit 6 # sortir du programme
fi

fin1=$(date +%s) # enregistre le temps fin d'exécuction première partie

echo "Souhaitez-vous sélectionner une centrale spécifique ? Oui = 1 " # demande à l'utilisateur si une centrale spécifique doit être sélectionnée
read choix # lecture de la réponse


if [[ "$choix" == "1" ]]; then # si l'utilisateur a choisi une centrale spécifique ( variable choix = 1) 
  echo "Veuillez entrer l'identifiant de la centrale (1-5) :" # demande à l'utilisateur de rentrer l'identifiant de la centrale
  read id_centrale # lecture de l'identifiant de la centrale
  debut2=$(date +%s) # enregistre le temps début d'exécuction deuxième partie
  if ! [[ "$id_centrale" =~ ^[1-5]$ ]]; then # vérifie si l'identifiant de la centrale est correct
    echo "Erreur : identifiant incorrect" # affiche erreur si l'identifiant de la centrale est incorrect
    affiche_aide
    exit 7 # sortir du programme
    
  fi

    fichier_final="/workspaces/C-WIRE/tests/${station}_${consommateur}_${id_centrale}.csv" # configuration du chemin pour fichier final avec centrale spécifique en fonction des paramètres
    fichier_tmp="/workspaces/C-WIRE/tmp/${station}_${consommateur}_${id_centrale}_tmp.csv" # configuration du chemin pour fichier temporaire en fonction des paramètres
    > "$fichier_final" # supprime le contenu du fichier final s'il existe
    echo " Station_${station}:Capacite:Consommation_${consommateur}" >> ./tests/${station}_${consommateur}_${id_centrale}.csv  # écriture de l'entête du fichier final
  
  if [ "$station" == "hvb" ] && [ "$consommateur" == "comp" ]; then # traitement des données en fonction des paramètres ( hvb et comp)
    grep -E "^$id_centrale+;[0-9]+;-;-;" "$1" | cut -d ';' -f 2,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
    
  elif [ "$station" == "hva" ] && [ "$consommateur" == "comp" ]; then # traitement des données en fonction des paramètres ( hva et comp)
    grep -E "^$id_centrale+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-"  "$1" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
    grep -E "^$id_centrale+;-;[0-9]+;-;[0-9]+;-;-;[0-9]" "$1" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
   
  elif [ "$station" == "lv" ]; then # traitement des données en fonction de la station lv
    if [ "$consommateur" == "comp" ]; then #  traitement des données en fonction du paramètre comp 
     grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
     grep -E "^$id_centrale+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':'>> "$fichier_tmp"
  
    elif [ "$consommateur" == "indiv" ]; then # traitement des données en fonction du paramètre indiv
      grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
      grep -E "^$id_centrale+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
    
    elif [ "$consommateur" == "all" ]; then # traitement des données en fonction du paramètre all
      grep -E "^$id_centrale+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire 
      grep -E "^$id_centrale+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
      grep -E "^$id_centrale+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
      
    fi
fi


else 
  debut2autre=$(date +%s) # enregistre le temps début d'exécuction deuxième partie si centrale spécifique non séléctionnée

  fichier_final="/workspaces/C-WIRE/tests/${station}_${consommateur}.csv" # configuration du chemin pour fichier final en fonction des paramètres
  fichier_tmp="/workspaces/C-WIRE/tmp/${station}_${consommateur}_tmp.csv" # configuration du chemin pour fichier temporaire en fonction des paramètres
  > "$fichier_final" # supprime le contenu du fichier final s'il existe
  echo " Station_${station}:Capacite:Consommation_${consommateur}" >> ./tests/${station}_${consommateur}.csv # écriture de l'entête du fichier final
  echo "Traitement effectué sur toutes les centrales du fichier " # affiche message  pour indiquer que traitement s'effectue sur toutes les centrales
  
  if [ "$station" == "hvb" ] && [ "$consommateur" == "comp" ]; then # traitement des données en fonction des paramètres ( hvb et comp)
    grep -E "^[0-9]+;[0-9]+;-;-;" "$1" | cut -d ';' -f 2,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
 
  elif [ "$station" == "hva" ] && [ "$consommateur" == "comp" ]; then # traitement des données en fonction des paramètres ( hva et comp)
    grep -E "^[0-9]+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-"  "$1" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
    grep -E "^[0-9]+;-;[0-9]+;-;[0-9]+;-;-;[0-9]" "$1" | cut -d ';' -f 3,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" 
   
  elif [ "$station" == "lv" ]; then # traitement des données en fonction de la station lv
    if [ "$consommateur" == "comp" ]; then #  traitement des données en fonction du paramètre comp
     grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
     grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"

    elif [ "$consommateur" == "indiv" ]; then # traitement des données en fonction du paramètre indiv 
      grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
      grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp"
    
    elif [ "$consommateur" == "all" ]; then # traitement des données en fonction du paramètre all
      grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0' | tr ';' ':' >> "$fichier_tmp" # filtrage et extraction des donnnées pour écriture dans le fichier temporaire
      grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':'>> "$fichier_tmp"
      grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]" "$1" | cut -d ';' -f 4,7,8 | tr '-' '0'  | tr ';' ':' >> "$fichier_tmp"
    
    fi
  fi
fi


if [ ! -f /workspaces/C-WIRE/codeC/main ]; then # vérifie si le fichier main existe dans le dossier codeC s'il n'existe pas on compile le code
  echo "Compilation en cours "  # affiche message de compilation en cours
  make -s -C /workspaces/C-WIRE/codeC || {  # compilation du code C
    echo "Erreur de compilation";  # affiche message d'erreur de compilation si échec
    exit 1; # sortir du programme
  }
fi

/workspaces/C-WIRE/codeC/main "$fichier_tmp" "$fichier_final" # exécution du code C avec les fichiers temporaires et finaux en paramètres

if [[ "$station" == "lv" && "$consommateur" == "all" ]]; then # traitement des données quand station lv et consommateur all selectionnés pour créer fichier min max
  fichier_minmax="/workspaces/C-WIRE/tmp/lv_all_tmp1.csv" # configuration du chemin pour fichier temporaires min max
  sort -t ':' -k3 -nr "$fichier_final" |tail -n +1 | head -n 10 > "$fichier_minmax" # tri des données par ordre décroissant et extraction des 10 premières lignes vers le fichier min max 
  sort -t ':' -k3 -n "$fichier_final" |tail -n +2 | head -n 10 >> "$fichier_minmax" # tri des données par ordre croissant et extraction des 10 premières lignes à la suite vers le fichier min max
  fichier_tmp_lv_min_max="/workspaces/C-WIRE/tmp/lv_all_minmax_tmp2.csv" # configuration du chemin pour autre fichier temporaires min max
  fichier_lv_min_max="/workspaces/C-WIRE/tests/lv_all_minmax.csv" # configuration du chemin pour fichier final min max
  echo "Min and Max 'capacity-load' extreme nodes " > "$fichier_lv_min_max" # écriture de l'entête du fichier final min max
  echo "Station_LV:Capacité:Consommation_all" >> "$fichier_lv_min_max" # écriture de l'entête colonnes dans fichier final min max
  awk -F ':' '{diff = $3 - $2; abs = (diff < 0) ? -diff : diff; print $0, abs}' OFS=':' "$fichier_minmax" > "$fichier_tmp_lv_min_max" # calcul de la différence entre capacité et consommation et écriture dans fichier temporaire min max
  sort -t ':' -k4 -nr "$fichier_tmp_lv_min_max" | cut -d ':' -f1-3 >> "$fichier_lv_min_max" # # Trie par la 4ème colonne ( ordre décroissant) et ajoute les 3 premières colonnes au fichier final.
 
fi

fin2=$(date +%s) # enregistre le temps fin d'exécuction deuxième partie

afficher_duree_execution(){ # fonction pour afficher la durée de traitement du programme
  if [[ "$choix" == "1" ]]; then # si l'utilisateur a choisi une centrale spécifique ( variable choix = 1)
  debuttmp=$debut2 # variable début partie 1
  else 
  debuttmp=$debut2autre # sinon variable début partie 2
  fi
  duree=$(( fin2 - debuttmp )) # calcule la durée d'exécution partie 2
  duree2=$(( fin1 - debut )) # calcule la durée d'exécution partie 1
  echo "Durée traitement : $(($duree+$duree2)) secondes" # affiche la durée d'exécution totale
}

afficher_duree_execution # appel de la fonction précédente

