#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

#include "histogram.h"

#define SIZE 'z' - 'a' + 1

struct Data {
  unsigned int histogram[SIZE];
  unsigned int num_blocks;
  block_t* blocks;
  int thread_id;
  int num_threads;
  struct Data* data;
  pthread_barrier_t* barrier;
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


  if(data->num_threads > 1) {
    unsigned int step = 2;

    while(data->thread_id % step == 0 && step <= data->num_threads) {
      printf("Id #%u at step = %u\n", data->thread_id, step);
      if(pthread_barrier_wait(data->barrier) == PTHREAD_BARRIER_SERIAL_THREAD) {
        printf("Id %u init at step = %u\n", data->thread_id, step);
        pthread_barrier_init(data->barrier, NULL, data->num_threads / step / 2);
      }

      unsigned int index = data->thread_id + step / 2;
      if(index < data->num_threads) {
        for(int i = 0; i < SIZE; ++i) {
          data->histogram[i] += data->data[index].histogram[i];
        }
      }

      step *= 2;
    }
  }
  return NULL;
}


void get_histogram(unsigned int nBlocks,
      block_t *blocks,
      histogram_t histogram,
      unsigned int num_threads) {

  pthread_t* thread = malloc(num_threads * sizeof(*thread));
  struct Data* data = calloc(num_threads, sizeof(*data));
  unsigned int blocksPerThread = nBlocks / num_threads;
  unsigned int remainingBlocks = nBlocks % num_threads;


  pthread_barrier_t barrier;

  if (num_threads > 1) {
    pthread_barrier_init(&barrier, NULL, num_threads / 2);
  }


  // Spawn N threads to process the data
  for(int i = 0; i < num_threads; i++) {
    data[i].num_blocks = blocksPerThread;
    data[i].thread_id = i;
    data[i].num_threads = num_threads;
    data[i].data = data;
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
  for(int i = 0; i < SIZE; i++) {
    histogram[i] = data[0].histogram[i];
  }
  
  if(num_threads > 1) {
    pthread_barrier_destroy(&barrier);
  }
  free(thread);
  free(data);
}


