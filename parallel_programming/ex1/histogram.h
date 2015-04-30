#ifndef HISTOGRAM_H_
#define HISTOGRAM_H_

#define BLOCKSIZE 8192 	// block size in byte
#define BYTESIZE 8 		// bits per byte
#define NALPHABET 26	// number of letters in the alphabet

typedef char block_t[BLOCKSIZE];
typedef unsigned int histogram_t[NALPHABET];

// produce histogram from blocks to histogram
void get_histogram(unsigned int nBlocks,
				   				 block_t *blocks,
				   				 unsigned int* histogram,
				   				 unsigned int num_threads);

// dump histogram to stdout
void print_histogram(histogram_t histogram);

#endif /* HISTOGRAM_H_ */
