#include "histogram.h"
#include <stdio.h>

void get_histogram(unsigned int nBlocks,
		   						 block_t *blocks,
		   						 unsigned int* histogram,
		   						 unsigned int num_threads) {

	unsigned int i, j;

	// build histogram
	for (i=0; i<nBlocks; i++) {
		for (j=0; j<BLOCKSIZE; j++) {
			if (blocks[i][j] >= 'a' && blocks[i][j] <= 'z')
				histogram[blocks[i][j]-'a']++;
			else if(blocks[i][j] >= 'A' && blocks[i][j] <= 'Z')
				histogram[blocks[i][j]-'A']++;
		}
	}

  printf("Number of blocks: %u\n", nBlocks);
}
