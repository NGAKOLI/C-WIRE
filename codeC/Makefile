CC = gcc # compilateur à utiliser

CFLAGS = -Wall -Wextra -std=c99 # définie les options du compilateur
TARGET = main # définie le nom de l'exécutable à générer
SRCS = main.c avl_traitement_fichier.c avl_gestion.c # liste des fichiers sources
OBJS = $(SRCS:.c=.o) # génère liste des fichiers objets à partir des fichiers sources ( remplace .c par .o)

all: $(TARGET) # règle du compilateur par défaut

$(TARGET): $(OBJS) # règle pour générer l'exécutable en fonction des fichiers objets
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) 

%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@ 

clean: # nettoie les fichiers générés
	rm -f $(TARGET) $(OBJS)

.PHONY: all clean
