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
  char* buffer = malloc(bufferSize * sizeof(*buffer));

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
    for(int i = 0; i < np; ++i) {
      displacement[i] = strlen - displacement[i] - sendCounts[i];
    }
  }
  MPI_Gatherv(buffer,		// send buffer
              bufferSize,	// send count
              MPI_CHAR,		// send type
              str,		// recv buffer, only for root
              sendCounts,	// recv counts are the same as send counts
              displacement,  // incoming displacement, only for root
              MPI_CHAR,		// recv type
              0, 		// root
              MPI_COMM_WORLD);	// communicator


  free(buffer);
  if(rank == 0) {    
    free(sendCounts);
    free(displacement);
  }
}
