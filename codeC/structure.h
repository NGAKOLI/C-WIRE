#ifndef STRUCTURE_H 
#define STRUCTURE_H 


typedef struct{  // définie structure stations 
    int id_station;  // identifiant de la station 
    long capacite; // capacité de la station 
    long som_conso; // somme des consommations en lien avec la station 
}Station;

typedef struct _arbre{ // définie structure d'un noeud de l'AVL
    Station station; // structure station de ce noeud
    struct _arbre*fgauche; // pointeur vers le fils gauche
    struct _arbre*fdroit; // pointeur vers le fils droit
    int equilibre; // équilibre du noeud
}Arbre;



#endif // STRUCTURE_H  