#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

#include "histogram.h"

#define SIZE 'z' - 'a' + 1

struct Data {
  int histogram[SIZE];
  int num_blocks;
  block_t* blocks;
  int num_threads;
  int thread_id;
  pthread_barrier_t* barrier;
};

void* build_histogram(void* arg) {

  struct Data* data = (struct Data*)arg;

  for (int i = 0; i < data->num_blocks; i++) {
    for (int j = 0; j < BLOCKSIZE; j++) {
      if (data->blocks[i][j] >= 'a' && data->blocks[i][j] <= 'z') {

        data->histogram[data->blocks[i][j] - 'a']++;

      } else if(data->blocks[i][j] >= 'A' && data->blocks[i][j] <= 'Z') {

        data->histogram[data->blocks[i][j]-'A']++;
      } 
    }
  }

  pthread_barrier_wait(data->barrier);
  int step = 2;
  int id = data->thread_id;
  while(thread_id > 0 && id % step == 0) {
 
    step = step << 1;
  }
  return NULL;
}

void get_histogram(unsigned int nBlocks,
      block_t *blocks,
      histogram_t histogram,
      unsigned int num_threads) {

 printf("#threads = %d\n", num_threads);

  pthread_barrier_t barrier;
  pthread_t* thread = malloc(num_threads * sizeof(*thread));
  struct Data* data = malloc(num_threads * sizeof(*data));
  int blocksPerThread = nBlocks / num_threads;
  int remainingBlocks = nBlocks % num_threads;

  pthread_barrier_init(&barrier, num_threads);

  // Spawn N threads to process the data
  for(int i = 0; i < num_threads; i++) {
    data[i].num_blocks = blocksPerThread;
    data[i].num_threads = num_threads;
    data[i].thread_it = i;
    data[i].barrier = &barrier;

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

  // Accumulate the results
  for(int i = 0; i < num_threads; i++) {
    for(int j = 0; j < SIZE; j++) {
      histogram[j] += data[i].histogram[j];
    }
  }

  pthread_barrier_destroy(&barrier);
  free(thread);
  free(data);
}
