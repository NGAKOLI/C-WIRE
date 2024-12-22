#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "structure.h"
#include "avl_gestion.h"
#include "avl_traitement_fichier.h"  


int main(int argc, char* argv[]){ // fonction principale
    if( argc != 3){ // vérification du nombre d'arguments ne doit pas être différent de 3
        exit(3); // sinon sortir du programme
    }
    FILE* fichier_tmp =fopen( argv[1] , "r" ); // ouverture du fichier temporaire en lecture
    FILE* fichier_final =fopen( argv[2] , "a+" ); // ouverture du fichier final en lecture et écriture

    if( fichier_tmp == NULL){ // vérification de l'ouverture du fichier temporaire
        printf("Ouverture du fichier impossible\n"); // affiche un message d'erreur
        printf("code d'erreur = %d \n", errno  ); // affiche le code d'erreur
        printf("Message d'erreur = %s \n", strerror(errno) ); // affiche le message d'erreur
        exit(1); // sortir du programme
    }

    traiterFichiers( fichier_tmp , fichier_final ); // appel fonction gestion global  pour récupérer les données d'un fichier et écrire le traitement dans fichier final

    fclose(fichier_tmp); // fermeture du fichier temporaire
    fclose(fichier_final); // fermeture du fichier final
        
    return 0;
}