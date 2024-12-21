#include <stdlib.h>
#include <stdio.h>
#include "avl_gestion.h" 

Arbre*creerArbre( int id_sta, long Capacite ){ // fonction de création d'un noeud de l'arbre
    Arbre*nouveau = malloc(sizeof(Arbre)); // allocation mémoire pour le noeud
    if( nouveau == NULL){ // vérification de l'allocation mémoire 
        printf("Erreur allocation mémoire"); // affiche un message d'erreur si l'allocation a échoué
        exit(1); // sortie du programme
    }
    nouveau->station.id_station = id_sta; // initialisation de l'identifiant de la station
    nouveau->station.capacite = Capacite; // initialisation de la capacité de la station
    nouveau->station.som_conso = 0; // initialisation de la somme des consommations en lien avec la station à 0
    nouveau->fgauche = NULL; // initialisation du fils gauche 
    nouveau->fdroit = NULL; // initialisation du fils droit 
    nouveau->equilibre = 0; // initialisation de l'équilibre du noeud

    return nouveau; // retourne le noeud créé
}

int max(int a, int b){ // fonction qui retourne le maximum entre deux valeurs
    if(a<=b){
        return b;
    }else{
        return a;
    }
}

int minbis(int a, int b){ // fonction qui retourne le minimum entre deux valeurs
    if(a<=b){
        return a;
    }else{
        return b;
    }
}

int min( int a, int b , int c){ // fonction qui retourne le minimum entre trois valeurs
    int minval = a;
    if( b < minval){
        minval = b;
    } if( c < minval){
        minval = c;
    }
    return minval;
}

int maxbis( int a, int b , int c){ // fonction qui retourne le maximum entre trois valeurs
    int maxval = a;
    if( b > maxval){
        maxval = b;
    } if( c > maxval){
        maxval = c;
    }
    return maxval;
}

Arbre*rotationGauche(Arbre*a){ // fonction de rotation gauche
    Arbre*pivot; // déclaration d'un pointeur vers un noeud
    int eq_a, eq_p; // déclaration des variables d'équilibre du noeud a et du noeud pivot
    pivot = a->fdroit; // le noeud pivot est le fils droit du noeud a
    a->fdroit = pivot->fgauche; // le fils droit du noeud a devient le fils gauche du noeud pivot
    pivot->fgauche = a; // le fils gauche du noeud pivot devient le noeud a
    eq_a = a->equilibre; // récupération de l'équilibre du noeud a
    eq_p = pivot->equilibre; // récupération de l'équilibre du noeud pivot
    a->equilibre = eq_a -max(eq_p ,0) -1 ; // calcul de l'équilibre du noeud a
    pivot->equilibre = min( eq_a-2, eq_a+eq_p -2, eq_p-1); // calcul de l'équilibre du noeud pivot
    a  = pivot; // le noeud a devient égal au noeud pivot
    return a; // retourne l'arbre

}

Arbre*rotationDroite(Arbre*a){ // fonction de rotation droite
    Arbre*pivot; // déclaration d'un pointeur vers un noeud
    int eq_a, eq_p; // déclaration des variables d'équilibre du noeud a et du noeud pivot
    pivot = a->fgauche;  // le noeud pivot est le fils gauche du noeud a
    a->fgauche = pivot->fdroit; //  fils gauche du noeud a devient le fils droit du noeud pivot
    pivot->fdroit = a; // le fils droit du noeud pivot devient le noeud a
    eq_a = a->equilibre; // récupére l'équilibre du noeud a
    eq_p = pivot->equilibre; // récupére l'équilibre du noeud pivot
    a->equilibre = eq_a - minbis(eq_p ,0) +1 ; // calcul de l'équilibre du noeud a
    pivot->equilibre = maxbis ( eq_a+2, eq_a+eq_p +2, eq_p+1); // calcul de l'équilibre du noeud pivot
    a  = pivot; // le noeud a devient égal au noeud pivot
    return a;   // retourne l'arbre

}

Arbre* doubleRotationGauche(Arbre*a){ // fonction pour la double rotation gauche
    a->fdroit=rotationDroite(a->fdroit); // rotation droite sur fils droit
    return rotationGauche(a);  // rotation gauche sur le noeud a
}

Arbre* doubleRotationDroite(Arbre*a){ // fonction pour la double rotation droite
    a->fgauche=rotationGauche(a->fgauche); // rotation gauche sur fils gauche
    return rotationDroite(a); // rotation droite sur le noeud a
}

Arbre*equilibrageAVL(Arbre*a){ // fonction d'équilibrage d'un AVL
    if(a->equilibre >= 2){ // si l'équilibre du noeud est supérieur ou égal à 2
        if(a->fdroit->equilibre >= 0){ // si l'équilibre du fils droit est supérieur ou égal à 0
            return rotationGauche(a); //  alors rotation gauche de a
        }else{
            return doubleRotationGauche(a); // sinon double rotation gauche de a
        }

    }else if(a->equilibre <= -2){ // si l'équilibre du noeud est inférieur ou égal à -2
        if(a->fgauche->equilibre <= 0){  // si l'équilibre du fils gauche est inférieur ou égal à 0
            return rotationDroite(a); // alors rotation droite de a
        }else{
            return doubleRotationDroite(a); // sinon double rotation droite de a
        } 
    }
    return a;
}

Arbre*insertionAVL(Arbre*a, int id_sta, long Capacite, int*h){ // fonction d'insertion dans un AVL
    if(a==NULL){  // si l'arbre est vide
        *h=1; // l'équilibre est à 1
        return creerArbre(id_sta,Capacite);  // création d'un nouveau noeud
    }else if( id_sta < a-> station.id_station){ // si l'identifiant de la station est inférieur à l'identifiant du noeud 
        a->fgauche = insertionAVL(a->fgauche, id_sta , Capacite  ,h); // insertion dans le sous arbre gauche
        *h = -*h; // regle différence d'équilibre 
    }else if(id_sta > a->station.id_station){ // si l'identifiant de la station est supérieur à l'identifiant du noeud
        a->fdroit = insertionAVL(a->fdroit, id_sta, Capacite,h ); // insertion dans le sous arbre droit

    }else{ // si l'identifiant de la station est égal à l'identifiant du noeud
        *h =0; // l'équilibre est à 0
        return a; // retourne arbre
    }if(*h != 0){ // si  différence d'équilibre est différent de 0
        a->equilibre = a->equilibre+*h; // calcul de l'équilibre
        a = equilibrageAVL(a); // équilibrage de l'arbre
        if(a->equilibre == 0){ // si l'équilibre est à 0
            *h = 0;  // différence d'équilibre reste pareil
        }else{ // sinon
            *h = 1; // différence d'équilibre est à 1
        }
    }
    return a; // retourne l'arbre
}