#include "histogram.h"

void get_histogram(char *buffer,
		   			 unsigned int* histogram,
		   			 unsigned int num_threads,
						 unsigned int chunk_size) {


	// build histogram
	for (int i=0; buffer[i]!=TERMINATOR; i++) {
		if (buffer[i] >= 'a' && buffer[i] <= 'z')
			histogram[buffer[i]-'a']++;
		else if(buffer[i] >= 'A' && buffer[i] <= 'Z')
			histogram[buffer[i]-'A']++;
	}
}
