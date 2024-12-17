#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>


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

Arbre*creerArbre( int id_sta, long Capacite ){
    Arbre* nouveau = malloc(sizeof(Arbre));
    if(nouveau == NULL){
        printf("Erreur allocation mémoire");
        exit(1);
    }
    nouveau->station.id_station = id_sta;
    nouveau->station.capacite = Capacite;
    nouveau->station.som_conso = 0;
    nouveau->fgauche = NULL;
    nouveau->fdroit = NULL;
    nouveau->equilibre = 0;

    return nouveau;
}

int max(int a, int b){
    if(a<=b){
        return b;
    }else{
        return a;
    }
}

int minbis(int a, int b){
    if(a<=b){
        return a;
    }else{
        return b;
    }
}

int min( int a, int b , int c){
    int minval = a;
    if( b < minval){
        minval = b;
    } if( c < minval){
        minval = c;
    }
    return minval;
}

int maxbis( int a, int b , int c){
    int maxval = a;
    if( b > maxval){
        maxval = b;
    } if( c > maxval){
        maxval = c;
    }
    return maxval;
}

Arbre*rotationGauche(Arbre*a){
    Arbre*pivot;
    int eq_a, eq_p;
    pivot = a->fdroit;
    a->fdroit = pivot->fgauche;
    pivot->fgauche = a;
    eq_a = a->equilibre;
    eq_p = pivot->equilibre;
    a->equilibre = eq_a -max(eq_p ,0) -1 ;
    pivot->equilibre = min( eq_a-2, eq_a+eq_p -2, eq_p-1);
    a  = pivot;
    return a;

}

Arbre*rotationDroite(Arbre*a){
    Arbre*pivot;
    int eq_a, eq_p;
    pivot = a->fgauche;
    a->fgauche = pivot->fdroit;
    pivot->fdroit = a;
    eq_a = a->equilibre;
    eq_p = pivot->equilibre;
    a->equilibre = eq_a - minbis(eq_p ,0) +1 ;
    pivot->equilibre = maxbis ( eq_a+2, eq_a+eq_p +2, eq_p+1);
    a  = pivot;
    return a;

}

Arbre* doubleRotationGauche(Arbre*a){
    a->fdroit=rotationDroite(a->fdroit);
    return rotationGauche(a);
}

Arbre* doubleRotationDroite(Arbre*a){
    a->fgauche=rotationGauche(a->fgauche);
    return rotationDroite(a);
}

Arbre*equilibrageAVL(Arbre*a){
    if(a->equilibre >= 2){
        if(a->fdroit->equilibre >= 0){
            return rotationGauche(a);
        }else{
            return doubleRotationGauche(a);
        }

    }else if(a->equilibre <= -2){
        if(a->fgauche->equilibre <= 0){
            return rotationDroite(a);
        }else{
            return doubleRotationDroite(a);
        }
    }
    return a;
}

Arbre*insertionAVL(Arbre*a, int id_sta, long Capacite, int*h){
    if(a==NULL){
        *h=1;
        return creerArbre(id_sta,Capacite); 
    }else if( id_sta < a-> station.id_station){
        a->fgauche = insertionAVL(a->fgauche, id_sta , Capacite  ,h);
        *h = -*h;
    }else if(id_sta > a->station.id_station){
        a->fdroit = insertionAVL(a->fdroit, id_sta, Capacite,h );

    }else{
        *h =0;
        return a;
    }if(*h != 0){
        a->equilibre = a->equilibre+*h;
        a = equilibrageAVL(a);
        if(a->equilibre == 0){
            *h = 0;
        }else{
            *h = 1;
        }
    }
    return a;
}


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
        fprintf(fichier, "%d;%ld;%ld\n", a->station.id_station, a->station.capacite, a->station.som_conso);
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

    while(fscanf(fichier, "%d;%ld;%ld", &id_stat, &capacite, &conso) != EOF){ 
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

int verifierargument(int argc){
    if( argc != 3){
        return 0;
    }
    return 1;
}

int main(int argc, char* argv[]){
    if( verifierargument(argc) != 1){
        exit(3);
    }
    FILE* fichier ;
    FILE* final = NULL;
    fichier=fopen( "hvb_comp.csv" , "r" );
    final = fopen("final.csv", "a+");

    if( fichier == NULL || final==NULL ){
        printf("Ouverture du fichier impossible\n");
        printf("code d'erreur = %d \n", errno  );
        printf("Message d'erreur = %s \n", strerror(errno) );
        exit(1);
    }

    traiterFichiers( fichier , final );

    fclose(fichier);
    fclose(final);

    return 0;
}