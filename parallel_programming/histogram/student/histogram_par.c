#include <pthread.h>
#include <stdlib.h>

#include "histogram.h"

#define SIZE 'z' - 'a' + 1

struct Data {
	int histogram[SIZE];
	int num_blocks;
	block_t* blocks;
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
	return NULL;
}

void get_histogram(unsigned int nBlocks,
			block_t *blocks,
			histogram_t histogram,
			unsigned int num_threads) {

	pthread_t* thread = malloc(num_threads * sizeof(*thread));
	struct Data* data = malloc(num_threads * sizeof(*data));
	int blocksPerThread = nBlocks / num_threads;

	// Spawn N-1 threads
	--num_threads;
	for(int i = 0; i < num_threads; i++) {
		data[i].num_blocks = blocksPerThread;
		data[i].blocks = blocks + i * blocksPerThread;
		pthread_create(&thread[i], NULL, build_histogram, &data[i]);
	}

	// Process the last bit in the main thread
	data[num_threads].num_blocks = blocksPerThread + nBlocks % num_threads;
	data[num_threads].blocks = blocks + (num_threads - 2) * blocksPerThread;
	build_histogram(&data[num_threads]);


	// Wait for the workers to complete
	for(int i = 0; i < num_threads; i++) {
		pthread_join(thread[i], NULL);
	}

	// Accumulate the results
	++num_threads;
	for(int i = 0; i < num_threads; i++) {
		for(int j = 0; j < SIZE; j++) {
			histogram[j] += data[i].histogram[j];
		}
	}

	free(thread);
	free(data);
}
