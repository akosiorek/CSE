NAME = quicksort
CC = gcc
CFLAGS = -std=gnu99 -fopenmp -fstrict-overflow -Werror -Wshadow -Wstrict-overflow=5 -pedantic
LDFLAGS = -lm -lrt -I $(CURDIR)

#error if student directory is not set
ifndef SDIR
SDIR = build
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

OBJ_SEQ = $(SDIR)/main.o $(SDIR)/$(NAME)_seq.o $(SDIR)/helper.o
OBJ_PAR = $(SDIR)/main.o $(SDIR)/$(NAME)_par.o $(SDIR)/helper.o
OBJ_UNIT = $(SDIR)/unit_test.o $(SDIR)/$(NAME)_par.o $(SDIR)/helper.o

# The dependency file names.
DEPS := $(OBJ_SEQ:.o=.d)

all: sequential sections unit_test

sequential: $(SDIR)/$(NAME)_seq

sections: $(SDIR)/$(NAME)_par

unit_test: $(SDIR)/unit_test

$(SDIR)/$(NAME)_seq : $(OBJ_SEQ)
	$(CC) -o $@ $(OBJ_SEQ) $(CFLAGS) $(LDFLAGS)

$(SDIR)/$(NAME)_par : $(OBJ_PAR)
	$(CC) -o $@ $(OBJ_PAR) $(CFLAGS) $(LDFLAGS)

$(SDIR)/unit_test: $(OBJ_UNIT)
	$(CC) -o $@ $(OBJ_UNIT) $(CFLAGS) $(LDFLAGS) 

$(SDIR)/%.o: %.c
	$(CC) -c -MMD -MP $< -o $@ $(CFLAGS) $(LDFLAGS)

clean:
	rm -f $(SDIR)/$(NAME)_par $(SDIR)/$(NAME)_seq $(SDIR)/unit_test $(SDIR)/*.o $(SDIR)/*.d
	
-include $(DEPS)

.PHONY : all sequential sections unit_test clean
