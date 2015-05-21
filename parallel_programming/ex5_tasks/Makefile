NAME = quicksort
CC = gcc
CFLAGS = -std=gnu99 -fopenmp -fstrict-overflow -Werror -Wshadow -Wstrict-overflow=5 -pedantic
LDFLAGS = -lm -lrt -I $(CURDIR)

#error if student directory is not set
ifndef BDIR
BDIR = build
endif

#Compiler flags
#if mode variable is empty, setting release build mode
ifeq ($(mode),debug)
	CFLAGS += -O0 -g
else
	mode = release
	CFLAGS += -O2
endif

VPATH = $(SDIR)
SRC = $(wildcard *.c) $(wildcard */*.c)

OBJ_SEQ = $(BDIR)/main.o $(BDIR)/$(NAME)_seq.o $(BDIR)/helper.o
OBJ_PAR = $(BDIR)/main.o $(BDIR)/$(NAME)_par.o $(BDIR)/helper.o
OBJ_UNIT = $(BDIR)/unit_test.o $(BDIR)/$(NAME)_par.o $(BDIR)/helper.o

# The dependency file names.
DEPS := $(OBJ_SEQ:.o=.d)

all: sequential parallel unit_test

sequential: $(BDIR)/$(NAME)_seq

parallel: $(BDIR)/$(NAME)_par

unit_test: $(BDIR)/unit_test

$(BDIR)/$(NAME)_seq : $(OBJ_SEQ)
	$(CC) -o $@ $(OBJ_SEQ) $(CFLAGS) $(LDFLAGS)

$(BDIR)/$(NAME)_par : $(OBJ_PAR)
	$(CC) -o $@ $(OBJ_PAR) $(CFLAGS) $(LDFLAGS)

$(BDIR)/unit_test: $(OBJ_UNIT)
	$(CC) -o $@ $(OBJ_UNIT) $(CFLAGS) $(LDFLAGS) 

$(BDIR)/%.o: %.c
	$(CC) -c -MMD -MP $< -o $@ $(CFLAGS) $(LDFLAGS)

clean:
	rm -f $(BDIR)/$(NAME)_par $(BDIR)/$(NAME)_seq $(BDIR)/unit_test $(BDIR)/*.o $(BDIR)/*.d
	
-include $(DEPS)

.PHONY : all sequential parallel unit_test clean
