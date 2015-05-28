#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "quicksort.h"
#include "helper.h"

#define SEQ_THRESH 100


static void quicksort_seq(int *a, int left, int right)
{
	if(left >= right)
	{
    return;
  }
  //printf("sq: left = %d, right = %d\n", left, right);
  int x = left, y = (left+right)/2, z =right;
  int pivotIdx = (a[x] <= a[y])
      ? ((a[y] <= a[z]) ? y : ((a[x] < a[z]) ? z : x))
      : ((a[x] <= a[z]) ? x : ((a[y] < a[z]) ? z : y));

  int pivotVal = a[pivotIdx];
  swap(a + pivotIdx, a + right);

  int swapIdx = left;

  for(int i=left; i < right; i++)
  {
    if(a[i] <= pivotVal)
    {
      swap(a + swapIdx, a + i);
      swapIdx++;
    }
  }
  swap(a + swapIdx, a + right);

  quicksort_seq(a, left, swapIdx - 1);
  quicksort_seq(a, swapIdx + 1, right);
}

static void quicksort_par(int *a, int left, int right, int num_threads)
{
	if((right - left) < SEQ_THRESH)
	{
    quicksort_seq(a, left, right);
    return;
  }

  //printf("left = %d, right = %d\n", left, right);
  int swapIdx;
  int x = left, y = (left+right)/2, z = right;
  int pivotIdx = (a[x] <= a[y])
      ? ((a[y] <= a[z]) ? y : ((a[x] < a[z]) ? z : x))
      : ((a[x] <= a[z]) ? x : ((a[y] < a[z]) ? z : y));

  int pivotVal = a[pivotIdx];
  swap(a + pivotIdx, a + right);

  swapIdx = left;

  for(int i=left; i < right; i++)
  {
    if(a[i] <= pivotVal)
    {
      swap(a + swapIdx, a + i);
      swapIdx++;
    }
  }
  swap(a + swapIdx, a + right);

  #pragma omp parallel sections
  { 
    //#pragma omp section 
    //{
    quicksort_par(a, left, swapIdx - 1, num_threads);
    //}
    #pragma omp section
    {
    quicksort_par(a, swapIdx + 1, right, num_threads);
    }
  }
}

void quicksort(int *a, int left, int right, int num_threads) {
  
  omp_set_num_threads(num_threads * 3);
  omp_set_nested(1);
  omp_set_max_active_levels(5);
  #pragma omp parallel
  {
    #pragma omp single
    quicksort_par(a, left, right, num_threads);
  }
}
