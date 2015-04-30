#include <stdio.h>

#include "histogram.h"

#define MAX(X,Y) ((X) > (Y) ? (X) : (Y))
#define NLINES 20

// get the maximum number of characters per letter
int max_chars(histogram_t histogram) {
	int i, max = 0;

	for (i=0; i<NALPHABET; ++i)
		max = MAX(histogram[i], max);

	return max;
}

void print_histogram(histogram_t histogram) {

	int max = max_chars(histogram);
	int i, j, y;

	// print line by line
	for (i=NLINES; i>=0; i--) {

		// calculate and print y labels
		y = (i*max) / NLINES;
		printf("%10d:", y);

		// print histogram
		for (j=0; j<NALPHABET; j++) {
			if (histogram[j] >= y)
				printf("%2c|", 0);
			else
				printf("%3c", 0);
		}
		printf("\n");
	}

	// print x labels
	printf("%12c", 0);
	for (j=0; j<NALPHABET; j++) {
		printf("%2c%c", 0, 97+j);
	}
}
