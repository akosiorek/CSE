#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>

#include "histogram.h"
#include "histogram_ref.h"

#define NTHREADS 4

int main(int argc, char **argv)
{
	int failed = 0;
	histogram_t histogram_ref = {0};
	struct stat st;
	char *buffer;
	unsigned int buffer_size;
	char *filename = "war_and_peace.txt";

   // get file size and allocate array
   stat(filename, &st);
   buffer_size = (unsigned int)st.st_size;
   buffer = (char*)malloc(buffer_size);

	// open file and read all blocks
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) {
		fprintf(stderr, "Could not open file %s", filename);
		exit(EXIT_FAILURE);
	}
	if (fread(buffer, 1, st.st_size, fp) == 0) {
		fprintf(stderr, "Could not read from file %s", filename);
		exit(EXIT_FAILURE);
	}

	// set the buffer
	set_buffer(buffer, buffer_size);

	// build the histogram (sequential)
	get_histogram_ref(histogram_ref);

	// build the histogram (parallel)
	set_buffer(buffer, buffer_size);
	histogram_t histogram = {0};
	get_histogram(histogram, NTHREADS);
	for (int i = 0; i < NALPHABET; i++) {
		if (histogram_ref[i] != histogram[i]) {
			fprintf(stderr, "Computation with %d threads failed:\n", NTHREADS);
			fprintf(stderr, "Wrong result for %c: %d (correct: %d)\n",
					i+97, histogram[i], histogram_ref[i]);
			failed = 1;
			break;
		}
	}

	free(buffer);
	return failed;
}
