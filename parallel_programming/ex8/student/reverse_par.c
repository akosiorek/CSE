#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#include <assert.h>
#include "helper.h"

void reverse(char *str, int strlen) {
	// parallelize this function and make sure to call reverse_str()
	// on each processor to reverse the substring.
	
  int np, rank;

  MPI_Comm_size(MPI_COMM_WORLD, &np);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if(rank >= strlen) {
    return;
  }

  int charsPerProcess = strlen / np;
  int charsLeft = strlen % np;

  int bufferSize = charsPerProcess + (charsLeft > rank);
  char* buffer = malloc((bufferSize + 1) * sizeof(*buffer));
  buffer[bufferSize] = '\0'; // string termination character

  int* sendCounts = NULL;
  int* displacement = NULL;

  if (rank == 0) {
    sendCounts = malloc(np * sizeof(*sendCounts));
    displacement = malloc(np * sizeof(*displacement));
    for(int i = 0; i < np; ++i) {
      sendCounts[i] = charsPerProcess + (charsLeft > 0);
      --charsLeft;
    }
    displacement[0] = 0;     
    for(int i = 1; i < np; ++i) {
      displacement[i] = displacement[i-1] + sendCounts[i-1];
    }


	
  }
  
  MPI_Scatterv(str,		// send buffer
               sendCounts,
               displacement,	// displacement from beg of str
               MPI_CHAR,	// send type
               buffer,
               bufferSize,
               MPI_CHAR,	// recv type
               0,		// root
               MPI_COMM_WORLD); // communicator



  reverse_str(buffer, bufferSize);

  if(rank == 0) {
   
    MPI_Status status;
    //handle own stuff
    for(int i = 0; i < bufferSize; ++i) {
      str[strlen - bufferSize + i] = buffer[i];
    }

    strlen -= bufferSize;
    for(int i = 1; i < np; ++i) {
      int currentLength = sendCounts[i];
      MPI_Recv(buffer, currentLength, MPI_CHAR, i, 0, MPI_COMM_WORLD, &status);
      for(int j = 0; j < currentLength; ++j) {
        str[strlen - currentLength + j] = buffer[j];
      }
      strlen -= currentLength;
    }

  } else {

    MPI_Send(buffer, bufferSize, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
  }

  free(buffer);
  if(rank == 0) {    
    free(sendCounts);
    free(displacement);
  }
}
