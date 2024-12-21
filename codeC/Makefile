CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = main
SRCS = main.c avl_traitement_fichier.c avl_gestion.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJS)

.PHONY: all clean
