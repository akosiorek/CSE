#ifndef HISTOGRAM_H_
#define HISTOGRAM_H_

#define BYTESIZE 8 		// bits per byte
#define NALPHABET 26	// number of letters in the alphabet
#define CHUNKSIZE 8192	// number of chunks for a task
#define TERMINATOR (char)255

typedef unsigned int histogram_t[NALPHABET];

// produce histogram from blocks to histogram
void get_histogram(char *input,
				   	 unsigned int* histogram,
				   	 unsigned int num_threads,
						 unsigned int chunk_size);

// dump histogram to stdout
void print_histogram(histogram_t histogram);

#endif /* HISTOGRAM_H_ */
