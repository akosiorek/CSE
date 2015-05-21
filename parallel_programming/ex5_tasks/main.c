#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "quicksort.h"
#include "helper.h"

#define NTHREADS 4
#define ELEMS 1000000

int main(int argc, char **argv)
{
	int elements = ELEMS;
	int num_threads = NTHREADS;
	int dump_array = 0;
	int c;
	while ((c = getopt(argc, argv, "t:e:d:")) != -1)
	{
		switch (c)
		{
		case 't':
			if (sscanf(optarg, "%d", &num_threads) != 1)
				goto error;
			break;

		case 'e':
			if (sscanf(optarg, "%d", &elements) != 1)
				goto error;
			break;

		case 'd':
			if (sscanf(optarg, "%d", &dump_array) != 1)
				goto error;
			break;

		case '?':
			error: printf(
			    "Usage:\n"
			    "-t \t number of threads used in computation\n"
			    "-e \t number of elements to be sorted using quicksort\n"
			    "-d \t dump array option (0 or 1)\n"
			    "\n"
			    "Example:\n"
			    "%s -t 4 -e 10000000 -d 1\n", argv[0]);
			exit(EXIT_FAILURE);
			break;
		}
	}

	struct timespec start, stop;
	int *a = random_int_array(elements, elements/2, 13);

	if (dump_array == 1) print_array(a, elements);

	clock_gettime(CLOCK_MONOTONIC, &start);

	quicksort(a, 0, elements-1, num_threads);

	clock_gettime(CLOCK_MONOTONIC, &stop);

	if (dump_array == 1) print_array(a, elements);

	printf("\nTime: %lf seconds\n", time_diff(&start, &stop, NULL));

	return 0;
}
