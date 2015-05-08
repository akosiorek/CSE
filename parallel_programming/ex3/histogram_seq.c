#include <stdlib.h>

#include "histogram.h"

void get_histogram(unsigned int* histogram,
		   			 unsigned int num_threads) {

	int size = 0;
	char *buffer = malloc(CHUNKSIZE);

	while ((size = get_chunk(buffer)) > 0) {

		// build histogram
		for (int i=0; i<size; i++) {
			if (buffer[i] >= 'a' && buffer[i] <= 'z')
				histogram[buffer[i]-'a']++;
			else if(buffer[i] >= 'A' && buffer[i] <= 'Z')
				histogram[buffer[i]-'A']++;
		}
	}

	free(buffer);
}
