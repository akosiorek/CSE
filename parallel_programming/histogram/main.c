#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <time.h>
#include <string.h>

#include "histogram.h"

int main(int argc, char* argv[]) {

	// declarations
	struct stat st;
	unsigned int nBlocks, i;
	block_t *blocks;
	struct timespec begin, end;
	histogram_t histogram = {0};
	char *filename = "war_and_peace.txt";
	long num_threads = 1, repetitions=0;
 
	// argument handling
	if (argc < 2 || argc > 4) {
		printf("usage: %s filename [#threads] [#repetition]\n", argv[0]);
		return 1;
	}
	if (argc >= 2)
		filename = argv[1];
	if (argc >= 3)
		if ((num_threads = strtol(argv[2], NULL, 0)) == 0 || num_threads < 0) {
    			fprintf(stderr, "#threads not valid!\n");
    			return 1;
  		}
	if (argc >= 4)
		if ((repetitions = strtol(argv[3], NULL, 0)) == 0 || repetitions < 0) {
    	fprintf(stderr, "#repetition not valid!\n");
    	return 1;
  	}

 	printf("\nProcess %s by %ld thread(s) with %ld repetition(s)\n\n", 
		filename, num_threads, repetitions);

	// get file size and allocate array
	stat(filename, &st);
	nBlocks = st.st_size / BLOCKSIZE;
	nBlocks += (st.st_size % BLOCKSIZE) == 0 ? 0 : 1;
	blocks = (block_t*)calloc(nBlocks, BLOCKSIZE * (repetitions+1));

	// open file and read all blocks
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) {
		fprintf(stderr, "Could not open file %s", filename);
		exit(EXIT_FAILURE);
	}
	if (fread(blocks, BLOCKSIZE, nBlocks, fp) == 0) {
		fprintf(stderr, "Could not read from file %s", filename);
		exit(EXIT_FAILURE);
	}

	// [optional] do the repetition
	for (i = 1; i < repetitions; i++)
		memcpy(blocks + i*nBlocks, blocks, nBlocks*BLOCKSIZE);

	// build the histogram	
	clock_gettime(CLOCK_MONOTONIC, &begin);
	get_histogram(nBlocks*(repetitions+1), blocks, histogram, num_threads);
	clock_gettime(CLOCK_MONOTONIC, &end);

	free(blocks);
	print_histogram(histogram);
	printf("\n\nTime: %.5f seconds\n", ((double)end.tv_sec + 1.0e-9*end.tv_nsec) -
									   ((double)begin.tv_sec + 1.0e-9*begin.tv_nsec));

	return 0;
}
