#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#include "histogram.h"

void build_histogram(unsigned int* histogram,
		   			 char* buffer, unsigned int size) {

  // build histogram
  for (int i=0; i<size; i++) {
    if (buffer[i] >= 'a' && buffer[i] <= 'z')
      histogram[buffer[i]-'a']++;
    else if(buffer[i] >= 'A' && buffer[i] <= 'Z')
      histogram[buffer[i]-'A']++;
  }
}

int incrementCyclic(int i, int limit) {
  return (i + 1) % limit;
}

struct Data {
  char data[CHUNKSIZE];
  int size;
};

struct CyclicBuffer {
  struct Data** buffer;
  int size;
  int read;
  int write;
  int occupied;
  pthread_mutex_t mutex;
  pthread_cond_t condRead;
  pthread_cond_t condWrite;
};

void buffer_init(struct CyclicBuffer* buffer, int size) {
  
  buffer->buffer = malloc(size * sizeof(*buffer));
  buffer->size = size;
  buffer->read = 0;
  buffer->write = 0;
  buffer->occupied = 0;
  pthread_mutex_init(&buffer->mutex, NULL);
  pthread_cond_init(&buffer->condRead, NULL);
  pthread_cond_init(&buffer->condWrite, NULL);
}

void buffer_destroy(struct CyclicBuffer* buffer) {
  for(int i = 0; i < buffer->size; ++i) {
    free(buffer->buffer[i]);
  }
  free(buffer->buffer);
  pthread_mutex_destroy(&buffer->mutex);
  pthread_cond_destroy(&buffer->condRead);
  pthread_cond_destroy(&buffer->condWrite);
  free(buffer);
}

struct Data* buffer_read(struct CyclicBuffer* buffer) {
  pthread_mutex_lock(&buffer->mutex);

  //wait for data to be read
  if(buffer->write == buffer->read) {
    pthread_cond_wait(&buffer->condRead, &buffer->mutex);
  }

  // read data and free a slot
  struct Data* data = buffer->buffer[buffer->read];
  buffer->buffer[buffer->read] = NULL;
  buffer->read = incrementCyclic(buffer->read, buffer->size);
  buffer->occupied--;

  // signal that a slot has just been freed
  pthread_cond_signal(&buffer->condWrite);

  pthread_mutex_unlock(&buffer->mutex);
  return data;
}

void buffer_write(struct CyclicBuffer* buffer, struct Data* data) {
  pthread_mutex_lock(&buffer->mutex);

  // wait for a slot to write
  if(buffer->occupied == buffer->size) {
    pthread_cond_wait(&buffer->condWrite, &buffer->mutex);
  }

  // write some data
  buffer->buffer[buffer->write] = data;
  buffer->write = incrementCyclic(buffer->write, buffer->size);

  // signal that some data has just been written
  pthread_cond_signal(&buffer->condRead);

  pthread_mutex_unlock(&buffer->mutex);
}


struct ConsumerData {
  struct CyclicBuffer* buffer;
  int* keepWorking;
  unsigned int* histogram;
};

struct ProducerData {
  struct CyclicBuffer* buffer;
  int* keepWorking;
};

void* producer(void* arg) {

  struct ProducerData* data = (struct ProducerData*)arg;
  *data->keepWorking = 1;

  struct Data* chunk = malloc(sizeof(*chunk)); 
  get_chunk(chunk->data);
  while(chunk->data != NULL) {
    buffer_write(data->buffer, chunk);
    chunk = malloc(sizeof(*chunk));
    get_chunk(chunk->data);
  }
 
  *data->keepWorking = 0;
  pthread_cond_broadcast(&data->buffer->condRead);

  return NULL;
}

void* consumer(void* arg) {

  struct ConsumerData* data = (struct ConsumerData*)arg;
  data->histogram = calloc(NALPHABET, 0);

  while(*data->keepWorking) {
    struct Data* chunk = buffer_read(data->buffer);
    if(chunk != NULL) {
      build_histogram(data->histogram, chunk->data, chunk->size);
    }
  }

  return NULL;
}


void get_histogram(unsigned int* histogram,
                   unsigned int num_threads) {
  
  // initialize stuff
  struct CyclicBuffer* buffer = malloc(sizeof(*buffer));
  buffer_init(buffer);

  pthread_t* threads = malloc(num_threads * sizeof(*threads));
  struct ConsumerData* consumerData = malloc((num_threads - 1) * sizeof(*consumerData));
  int keepWorking = 1;

  // create producer
  struct ProducerData producerData;
  producerData.buffer = buffer;
  producerData.keepWorking = &keepWorking;
  pthread_create(&threads[0], NULL, producer, NULL);

  // create consumers
  for(int i = 1; i < num_threads; ++i) {
    
    consumerData[i - 1].buffer = buffer;
    consumerData[i - 1].keepWorking = &keepWorking;

    pthread_create(&threads[i], NULL, consumer, &consumerData[i - 1]);
  }


  // finalize consumers
  for(int i = 1; i < num_threads; ++i) {
    pthread_join(thread[i], NULL);
    for(int j = 0; j < NALPHABET; j++) {
        histogram[j] += consumerData[i].histogram[j];
    }
    free(data[i].histogram);
  }

  // finalize producer
  pthread_join(threads[0], NULL);

  buffer_destroy(buffer);
  free(threads);
  free(consumerData);
}
