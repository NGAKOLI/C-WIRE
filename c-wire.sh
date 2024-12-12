echo 'Chemin du fichier:$1'
echo 'type de station'
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
if["$powerplant" -eq 0]; then 
 grep -E "^[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*$" "$DATA_FILE" > "$FILTERED_FILE"
 else 
 fi

mkdir -p tmp graph
rm -rf tmp/*
grep 
  cat  grep "$1" 
  if["$station"=="hvb" || "$station"=="hva"]; then
  grep -E "[0-9];[0-9]+;-;-;[0-9]+;-">tmp1.csv

 grep -E "[0-9];-;[0-9];-;[0-9]+;-">tmp11.csv
fi
if ["$station"=="lv"];then
if ["$consumer"=="indiv"]; then
grep -E "[0-9];-;-;[0-9]+;[0-9]+;-">tmp1.csv
else
grep -E "[0-9];-;-;[0-9]+;-;[0-9];-">tmp1.csv
fi
fi
  //Filtre lesdonnées
cat "tmp1.csv" | cut -d ';' -f 2,7,8 |tr '-' '0'>fileFiltre.csv
