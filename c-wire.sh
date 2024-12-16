echo "Chemin du fichier:$1"
station="$2"
consumer="$3"
powerplant="$4"

test

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

