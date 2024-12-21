# C-WIRE

## Table des matières

-[Description](#description)
-[Fonctionnalités](#fonctionnalités)
-[Structure du projet](#structure-du-projet)
-[Utilisation](#utilisation)
-[Arguments](#arguments)
-[Aide](#aide)
-[Auteurs](#auteurs)

## Description

C-WIRE est un projet qui permet de faire la synthèse de données d’un système de distribution d’électricité. Le projet comprend un script shell (`c-wire.sh`) pour filtrer et préparer les données, ainsi qu'un programme C pour traiter ces données.

## Fonctionnalités

- Filtrage des données en fonction du type de station et de consommateur rentré en paramètre par l'utilisateur.
- Option pour sélectionner une centrale électrique spécifique.
- Génération de fichiers de sortie avec les données filtrées par Station / Capacité / Consommation.
- Calcul différence entre la capacité totale et la consommation totale (min et max) pour les stations `lv` avec le type de consommateur `all`.
- Affichage du temps d'exécution du programme

## Structure du projet

- `c-wire.sh`: Script shell pour filtrer les données.
- `codeC/`: Répertoire contenant le code  C.
  - `main.c`: Fichier principal du programme C.
  - `structure.h`: Définition des structures de données.
  - `avl_gestion.c` et `avl_gestion.h`: Gestion arbre type AVL.
  - `avl_traitement_fichier.c` et `avl_traitement_fichier.h`: Traitement du fichier de donnée avec arbre AVL.
  - `Makefile`: Fichier Makefile pour compiler le programme C.
- `tests/`: Répertoire pour les fichiers de test générés.
- `tmp/`: Répertoire pour les fichiers temporaires.


## Utilisation

- Pour exécuter ce programme utilisez la commande suivante :

```bash
bash c-wire.sh <chemindufichier> <type_station> <type_consommateur>
```

ou

```bash
./c-wire.sh <chemindufichier> <type_station> <type_consommateur>
```

- Pour sélectionner une centrale spécifique, saisissez :
```bash
  1 
```   
dans le terminal suite à la question suivante 
_"Souhaitez-vous sélectionner une centrale spécifique ? (Oui = 1)"_\
Ensuite, saisissez la valeur correspondant à la centrale souhaitée :\
     Valeurs possibles : 1, 2, 3, 4 ou 5\
    > Si vous ne souhaitez aucune centrale spécifique, saisissez une valeur quelconque dans le terminal.

### Arguments

- `<chemindufichier>`: Chemin vers le fichier `.dat` contenant les données.
- `<type_station>`: Type de station (`hvb`, `hva`, `lv`).
- `<type_consommateur>`: Type de consommateur (`comp`, `indiv`, `all`).

    Combinaisons impossibles
     - hvb avec indiv ou all
     - hva avec indiv ou all

### Exemple

```bash
./c-wire.sh /workspaces/C-WIRE/input/c-wire_v25.dat hvb comp
```

## Aide

- Pour obtenir de l'aide lors de l'utilisation du programme utilisez la commande suivante :

```bash
./c-wire.sh  -h
```

## Auteurs

- [NGAKOLI Franck][LANGLAIS--SIMON Antoine]


