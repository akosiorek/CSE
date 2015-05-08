#ifndef HISTOGRAM_H_
#define HISTOGRAM_H_

#define NALPHABET 26	// number of letters in the alphabet
#define CHUNKSIZE 8192	// number of chunks for a task

typedef unsigned int histogram_t[NALPHABET];

// produce histogram from blocks to histogram
void get_histogram(unsigned int* histogram,
				   	 unsigned int num_threads);


// copies next chunk into *chunk and returns the size of the chunk
int get_chunk(char *chunk);

// internal: sets the global buffer and its size
void set_buffer(char *buffer,
					 unsigned int buffer_size);

// dump histogram to stdout
void print_histogram(histogram_t histogram);

#endif /* HISTOGRAM_H_ */
