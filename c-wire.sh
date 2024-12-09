echo 'Chemin du fichier:$1'

station=$2
consumer=$3
powerplant=$4


if ["$station"!="hvb"] && ["$station"!="hva"] &&  ["$station"!="lv"]; then
  
  echo 'saisie incorrect:entrer hvb,hva ou lv'
else
if["$station" -eq "hvb"];then
  cat 'c-wire_v00.dat' |grep -E "[0-9]+;[0-9]+;-;-;">"$1"
  elif ["$station"-eq "hva"]; then
  cat 'c-wire_v00.dat' | grep -E "[0-9]+;-;[0-9]+;-;">"$1"
  elif ["$station" -eq "lv"];then
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


  cat  grep "$1" 
cat | cut 
cat  
if ["$2" -eq 0] && ["$3" -ne 0] ; then
cat 'data.txt' | grep -E "^$1;.*$"
