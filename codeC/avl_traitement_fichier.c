#include <stdlib.h>
#include <stdio.h>
#include "avl_traitement_fichier.h"

Arbre*sommeConsommation(Arbre*a, long conso, int id_stat){
    if(a==NULL){
        exit(2);
    }else if( id_stat > a->station.id_station){
        a->fdroit  = sommeConsommation(a->fdroit, conso , id_stat);
    }else if( id_stat < a ->station.id_station){
        a->fgauche = sommeConsommation(a->fgauche, conso, id_stat);
    }else{
        a->station.som_conso = a->station.som_conso + conso;
    }

    return a;
}

void ajouterFichier(Arbre*a, FILE* fichier){  
    if( a!=NULL ){ 
        ajouterFichier(a->fgauche, fichier);  
        fprintf(fichier, "%d:%ld:%ld\n", a->station.id_station, a->station.capacite, a->station.som_conso);
        ajouterFichier(a->fdroit, fichier);
    }
    free(a);  
}

Arbre*extraireFichier(FILE* fichier){ 
    Arbre*a = NULL;

    int h = 0;
    int id_stat; 
    long capacite; 
    long conso;  

    while(fscanf(fichier, "%d:%ld:%ld", &id_stat, &capacite, &conso) != EOF){ 
        if(conso == 0){  
            a = insertionAVL(a, id_stat, capacite, &h);  
        }
        else{  
            a = sommeConsommation(a, conso, id_stat);  
        }
    }
    return a;  
}

void traiterFichiers( FILE* fichier , FILE* final){
    Arbre* a = NULL;
    a = extraireFichier(fichier);
    ajouterFichier(a , final);
}