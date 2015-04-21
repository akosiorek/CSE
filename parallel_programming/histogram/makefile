CC=gcc
FLAGS=-Wpedantic -O2 -DNDEBUG -std=c99
DFLAGS=-g
LDFLAGS=-pthread
PARALLEL=-DPARALLEL
NAME=histogram
SRC=main.c

sequential: 
	$(CC) -o $(NAME) $(FLAGS) $(LDFLAGS) $(SRC)

parallel:
	$(CC) -o $(NAME) $(FLAGS) $(LDFLAGS) $(PARALLEL) $(SRC)

tar:
	tar -cf $(NAME).tar main.c makefile
