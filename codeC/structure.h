#ifndef STRUCTURE_H
#define STRUCTURE_H


typedef struct{
    int id_station;
    long capacite;
    long som_conso;
}Station;

typedef struct _arbre{
    Station station;
    struct _arbre*fgauche;
    struct _arbre*fdroit;
    int equilibre;
    
}Arbre;



#endif // STRUCTURE_H