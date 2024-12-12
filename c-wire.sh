echo 'Chemin du fichier:$1'

station=$2
consumer=$3
powerplant=$4


if ["$station"!="hvb"] && ["$station"!="hva"] &&  ["$station"!="lv"]; then
  
  echo 'saisie incorrect:entrer hvb,hva ou lv'
else
if["$station"=="hvb"];then
  cat 'c-wire_v00.dat' |grep -E "[0-9]+;[0-9]+;-;-;">"$1"
  elif ["$station"=="hva"]; then
  cat 'c-wire_v00.dat' | grep -E "[0-9]+;-;[0-9]+;-;">"$1"
  elif ["$station"=="lv"];then
  cat 'c-wire_v00.dat' | grep -E "[0-9]+;-;[0-9]+;[0-9]+;">"$1"
  fi
  fi

if ["station"=="hvb"] && ["$consumer"=="all"] && ["$consumer"=="indiv"] && ["$consumer"!="comp"]; then
 echo 'erreur'
 fi
 if ["station"=="hva"] && ["$consumer"=="all"] && ["$consumer"=="indiv"] && ["$consumer"!="comp"]; then
 echo 'erreur'
 fi
 if ["station"=="lv"] && ["$consumer"=="all"] && ["$consumer"=="indiv"] && ["$consumer"=="comp"]; then
 
fi

echo " souhaitez-vous une centrale spécifique ? $4"  

if["powerplant"==[0-5]+]

  cat  grep "$1" 
cat | cut 
cat  
if ["$2" -eq 0] && ["$3" -ne 0] ; then
cat 'data.txt' | grep -E "^$1;.*$"
