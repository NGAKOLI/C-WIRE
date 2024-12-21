#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "structure.h"
#include "avl_gestion.h"
#include "avl_traitement_fichier.h"


int main(int argc, char* argv[]){
    if( argc != 3){
        exit(3);
    }
    FILE* fichier_tmp =fopen( argv[1] , "r" );
    FILE* fichier_final =fopen( argv[2] , "a+" );

    if( fichier_tmp == NULL){
        printf("Ouverture du fichier impossible\n");
        printf("code d'erreur = %d \n", errno  );
        printf("Message d'erreur = %s \n", strerror(errno) );
        exit(1);
    }

    traiterFichiers( fichier_tmp , fichier_final );

    fclose(fichier_tmp);
    fclose(fichier_final);
        
    return 0;
}