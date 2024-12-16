echo "Chemin du fichier:$1"
station=$2
<<<<<<< HEAD
consumer="$3"
powerplant="$4"


if [ "$station" != hvb ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then
    echo "saisie incorrect:entrer hvb,hva ou lv"
    exit 1;  
fi
if [ "$station" == "hvb" ] && [[ "$consumer" == "all" || "$consumer" == "indiv" || "$consumer" != "comp" ]]; then
 echo 'saisir: comp'
 exit 2;
elif [ "$station" == "hva" ] && [[ "$consumer" == "all" || "$consumer" == "indiv" || "$consumer" != "comp" ]]; then
  echo 'saisir: dcomp'
elif [ "$station" == "lv" ] && [[ "$consumer" != "all" || "$consumer" != "indiv" || "$consumer" != "comp" ]]; then
 echo "saisir:'all','indiv',comp "
 fi


if [ "$station" == "hvb" ]; then 
   grep -E "[0-9]+;[0-9]+;-;-;" "$1">Hvb.csv
elif [ "$station" == "hva" ]; then
   cat"$1" | grep -E "[0-9]+;-;[0-9]+;-;" "$1" >Hva.csv
elif [ "$station" == "lv" ];then
  cat "$1" | grep -E "[0-9]+;-;[0-9]+;[0-9]+;">Lv.csv
fi 

=======
consommateur=$3
centrale=$4


if [ "$station" != "hvb" ] && [ "$station" != "hva "] &&  [ " $station" != "lv" ]; then
  echo 'Erreur : saisie incorrect. Entrer hvb, hva ou lv'     //  En plus du message d’erreur, l’aide doit aussi s’afficher en dessous, comme si l’utilisateur avait tapé l’option -h
fi

if [ "$station" = "hvb" ];then
  cat 'c-wire_v00.dat' | grep -E "[0-9]+;[0-9]+;-;-;" > "$1"
  elif [ "$station" = "hva"]; then
  cat 'c-wire_v00.dat' | grep -E "[0-9]+;-;[0-9]+;-;" > "$1"
  elif [ "$station" = "lv" ];then
  cat 'c-wire_v00.dat' | grep -E "[0-9]+;-;[0-9]+;[0-9]+;" > "$1"
 
  fi
  

if [ "$station" = "hvb" ] && [ "$consommateur" != "comp" ]; then
 echo 'Erreur : seul les consommateurs entreprise sont valide pour hvb'
fi


if [ "$station" = "hva" ] && [ "$consommateur" != "comp" ] ; then
 echo 'Erreur : seul les consommateurs entreprise sont valide pour hva'
fi
 
if [ "$station" = "lv" ] && { [ "$consommateur" != "all" ] && [ "$consommateur" != "indiv" ] && [ "$consommateur" != "comp" ]; }; then
  echo "Erreur : consommateur incorrect  "
fi

echo " souhaitez-vous une centrale spécifique ? $4"  

if[ "$centrale" = [0-5]+]

  
 cat  grep "$1" 
cat | cut 
cat  
if ["$2" -eq 0] && ["$3" -ne 0] ; then
cat 'data.txt' | grep -E "^$1;.*$"
>>>>>>> origin/main
