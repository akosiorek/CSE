#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

#include "histogram.h"

#pragma GCC optimize (3)

struct Data {

  pthread_mutex_t* restrict mutex;
  char** globalBuffer;
  unsigned int chunkSize;
  unsigned int* restrict histogram;
  char pad[64 - sizeof(int) - 3 * sizeof(int*)];
};


void buildHistogram(const char* restrict buffer,
             int size,
		   			 unsigned int* restrict histogram) {

	// build histogram
	for (int i=0; i < size; i++) {
    if ((buffer[i]|32) >= 'a' && (buffer[i]|32) <= 'z')
      histogram[(buffer[i]|32)-'a']++;
    }
}


char* getDataChunk(struct Data* restrict data) {

  pthread_mutex_lock(data->mutex);

  char* restrict dataChunkPtr = *data->globalBuffer;
  if(*dataChunkPtr == TERMINATOR) {
    dataChunkPtr = NULL;
  } else {
    *data->globalBuffer += data->chunkSize;
  }
  pthread_mutex_unlock(data->mutex);

  return dataChunkPtr;
}

void* histogramThreadFun(void* restrict ptr) {

  struct Data* restrict data = (struct Data*)ptr;
  unsigned int size = data->chunkSize;
  unsigned int* histogram = calloc(NALPHABET, sizeof(*histogram));
  const char* restrict dataChunk = getDataChunk(data);
  while(dataChunk) {
    buildHistogram(dataChunk, size, histogram);
    dataChunk = getDataChunk(data);
  }

  data->histogram = histogram;
  return NULL;
}



void get_histogram(char* buffer,
		   			 unsigned int* restrict histogram,
		   			 unsigned int num_threads,
						 unsigned int chunk_size) {


  pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
  pthread_t* thread = malloc(num_threads * sizeof(*thread));
  struct Data* restrict data = malloc(num_threads * sizeof(*data));


  for(int i = 0; i < num_threads; ++i) {
    data[i].mutex = &mutex;
    data[i].globalBuffer = &buffer;
    data[i].chunkSize = chunk_size;

    pthread_create(&thread[i], NULL, histogramThreadFun, &data[i]);
  }

  for(int i = 0; i < num_threads; ++i) {
    pthread_join(thread[i], NULL);
    for(int j = 0; j < NALPHABET; j++) {
        histogram[j] += data[i].histogram[j];
    }
    free(data[i].histogram);
  }

  free(thread);
  free(data);
}

