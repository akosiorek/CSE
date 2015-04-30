#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

#include "histogram.h"


struct Data {

  pthread_mutex_t* mutex;
  char** globalBuffer;
  unsigned int chunkSize;
  unsigned int* histogram;
};


void buildHistogram(const char *buffer,
             int size,
		   			 unsigned int* histogram) {

	// build histogram
	for (int i=0; i < size; i++) {
		if (buffer[i] >= 'a' && buffer[i] <= 'z')
			histogram[buffer[i]-'a']++;
		else if(buffer[i] >= 'A' && buffer[i] <= 'Z')
			histogram[buffer[i]-'A']++;
    else if(buffer[i] == TERMINATOR)
      break;
  } 
}

char* getDataChunk(struct Data* data) {

  pthread_mutex_lock(data->mutex);

  char* dataChunkPtr = *data->globalBuffer;
  if(*dataChunkPtr == TERMINATOR) {
    dataChunkPtr = NULL;
  } else {
    *data->globalBuffer += data->chunkSize;
  }
  pthread_mutex_unlock(data->mutex);

  //printf("%p\n", dataChunkPtr);
  return dataChunkPtr;
}

void* histogramThreadFun(void* ptr) {

  struct Data* data = (struct Data*)ptr;
  unsigned int size = data->chunkSize;
  unsigned int* histogram = calloc(NALPHABET, sizeof(*histogram));
  const char* dataChunk = getDataChunk(data);
  while(dataChunk) {
    buildHistogram(dataChunk, size, histogram);
    dataChunk = getDataChunk(data);
  }

  data->histogram = histogram;
  return NULL;
}



void get_histogram(char *buffer,
		   			 unsigned int* histogram,
		   			 unsigned int num_threads,
						 unsigned int chunk_size) {


  pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
  pthread_t* thread = malloc(num_threads * sizeof(*thread));
  struct Data* data = malloc(num_threads * sizeof(*data));


  for(int i = 0; i < num_threads; ++i) {
    data[i].mutex = &mutex;
    data[i].globalBuffer = &buffer;
    data[i].chunkSize = chunk_size;

    pthread_create(&thread[i], NULL, histogramThreadFun, &data[i]);
  }

  for(int i = 0; i < NALPHABET; ++i) {
    histogram[i] = 0;
  }

  for(int i = 0; i < num_threads; ++i) {
    pthread_join(thread[i], NULL);
    for(int j = 0; j < NALPHABET; j++) {
        histogram[j] += data[i].histogram[j];
    }
    free(data[i].histogram);
  }

 // pthred_mutex_destroy(mutex);
  free(thread);
  free(data);
}

