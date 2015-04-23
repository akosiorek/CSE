#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

#include "histogram.h"

#define SIZE 'z' - 'a' + 1

struct Data {
  unsigned int histogram[SIZE];
  unsigned int num_blocks;
  block_t* blocks;
};


void* build_histogram(void* arg) {

  struct Data* data = (struct Data*)arg;

  for(int i = 0; i < SIZE; ++i) {
    data->histogram[i] = 0;
  }

  for (int i = 0; i < data->num_blocks; i++) {
    for (int j = 0; j < BLOCKSIZE; j++) {
      if (data->blocks[i][j] >= 'a' && data->blocks[i][j] <= 'z') {

        data->histogram[data->blocks[i][j] - 'a'] += 1;

      } else if(data->blocks[i][j] >= 'A' && data->blocks[i][j] <= 'Z') {

        data->histogram[data->blocks[i][j]-'A'] += 1;
      } 
    }
  }
  return NULL;
}


void get_histogram(unsigned int nBlocks,
      block_t *blocks,
      histogram_t histogram,
      unsigned int num_threads) {

  pthread_t* thread = malloc(num_threads * sizeof(*thread));
  struct Data* data = malloc(num_threads * sizeof(*data));
  unsigned int blocksPerThread = nBlocks / num_threads;
  unsigned int remainingBlocks = nBlocks % num_threads;

  // Spawn N threads to process the data
  for(int i = 0; i < num_threads; i++) {
    data[i].num_blocks = blocksPerThread;

    if(remainingBlocks > 0) {
        data[i].num_blocks += 1;
        --remainingBlocks;
    }

    data[i].blocks = blocks;
    blocks += data[i].num_blocks;
    pthread_create(&thread[i], NULL, build_histogram, &data[i]);
  }

  // Wait for the workers to complete
  for(int i = 0; i < num_threads; i++) {
    pthread_join(thread[i], NULL);
  }

  for(int i = 0; i < SIZE; ++i) {
    histogram[i] = 0;
  }

  // Accumulate the results
  for(int i = 0; i < num_threads; i++) {
    for(int j = 0; j < SIZE; j++) {
      histogram[j] += data[i].histogram[j];
    }
  }


  free(thread);
  free(data);
//if(num_threads == 5)
//  for(int i = 0; i < 'z' - 'a' + 1; i++) {
//    printf("%c:\t%u\n", (char)('a'+i), histogram[i]);
//  }
}


