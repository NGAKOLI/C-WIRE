#include <stdlib.h>
#include <stdio.h>
#include "avl_traitement_fichier.h" 

Arbre*sommeConsommation(Arbre*a, long conso, int id_stat){ // fonction pour ajouter la consommation à une station
    if(a==NULL){ // si l'arbre est vide
        exit(2); // sortie du programme
    }else if( id_stat > a->station.id_station){   // si l'identifiant de la station est supérieur à l'identifiant du noeud
        a->fdroit  = sommeConsommation(a->fdroit, conso , id_stat); // parcour du sous arbre droit
    }else if( id_stat < a ->station.id_station){ // si l'identifiant de la station est inférieur à l'identifiant du noeud
        a->fgauche = sommeConsommation(a->fgauche, conso, id_stat); // parcour du sous arbre gauche
    }else{ // si l'identifiant de la station est égal à l'identifiant du noeud
        a->station.som_conso = a->station.som_conso + conso; // ajout de la consommation à la station
    }

    return a; // retourne l'arbre
}

void ajouterFichier(Arbre*a, FILE* fichier){  // fonction pour écrire  les données de l'AVL dans un fichier
    if( a!=NULL ){     // si l'arbre n'est pas vide
        ajouterFichier(a->fgauche, fichier);   // parcour du sous arbre gauche
        fprintf(fichier, "%d:%ld:%ld\n", a->station.id_station, a->station.capacite, a->station.som_conso); // écriture des données de la station dans le fichier
        ajouterFichier(a->fdroit, fichier); // parcour du sous arbre droit
    }
    free(a);   // libération de la mémoire
}

Arbre*extraireFichier(FILE* fichier){  // fonction pour extraire les données d'un fichier et construire l'AVL
    Arbre*a = NULL;  // initialisation d'un arbre

    int h = 0; // initialisation de  variable pour gérer l'équilibre de l'arbre
    int id_stat; // variable identifiant de la station
    long capacite; // variable capacité de la station
    long conso;   // variable consommation de la station

    while(fscanf(fichier, "%d:%ld:%ld", &id_stat, &capacite, &conso) != EOF){  // lecture  ligne  du fichier
        if(conso == 0){   // si la consommation est nulle c'est une station 
            a = insertionAVL(a, id_stat, capacite, &h);   // insertion de la station dans l'arbre
        }
        else{  
            a = sommeConsommation(a, conso, id_stat);   // ajout la consommation à une des station de l'arbre ( noeud de l'arbre)
        }
    }
    return a;   // retourne l'arbre
}

void traiterFichiers( FILE* fichier , FILE* final){ // fonction gestion global  pour récupérer les données d'un fichier et écrire dans le traitement dans fichier final
    Arbre* a = NULL; // initialisation d'un arbre
    a = extraireFichier(fichier); // construction de l'arbre avec fichier temporaire
    ajouterFichier(a , final); // écriture des données de L'AVL dans le fichier final
}