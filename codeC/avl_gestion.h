#ifndef AVL_GESTION_H
#define AVL_GESTION_H
#include "structure.h" // inclusion des structures ( station et AVL )

// Liste des fonctions de gestion de l'AVL
Arbre*creerArbre( int id_sta, long Capacite );
int max(int a, int b); 
int minbis(int a, int b);
int min( int a, int b , int c);
int maxbis( int a, int b , int c);
Arbre*rotationGauche(Arbre*a);
Arbre*rotationDroite(Arbre*a);
Arbre* doubleRotationGauche(Arbre*a);
Arbre* doubleRotationDroite(Arbre*a);
Arbre*equilibrageAVL(Arbre*a);
Arbre*insertionAVL(Arbre*a, int id_sta, long Capacite, int*h);


#endif // AVL_GESTION_H