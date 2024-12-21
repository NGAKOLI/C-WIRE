#ifndef AVL_TRAITEMENT_FICHIER_H
#define AVL_TRAITEMENT_FICHIER_H
#include <stdio.h>
#include <stdlib.h>
#include "avl_gestion.h" // inclusion des fonctions pour gérer AVL 

// Liste des fonctions de traitement de fichiers
Arbre*sommeConsommation(Arbre*a, long conso, int id_stat);
void ajouterFichier(Arbre*a, FILE* fichier);
Arbre*extraireFichier(FILE* fichier);
void traiterFichiers( FILE* fichier , FILE* final);


#endif // AVL_TRAITEMENT_FICHIER_H