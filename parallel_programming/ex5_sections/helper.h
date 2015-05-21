#ifndef HELPER_H_
#define HELPER_H_

#include <time.h>

#include "quicksort.h"


double time_diff(const struct timespec *first, const struct timespec *second, struct timespec *diff);

int * random_int_array(long size, int num_swaps, unsigned int seed);

void print_array(int *a, int elements);

void swap(int *a, int *b);

void quicksort_ref(int *a, int left, int right, int num_threads);

#endif /* HELPER_H_ */
