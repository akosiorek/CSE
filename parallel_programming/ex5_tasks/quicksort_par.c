#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "quicksort.h"
#include "helper.h"

#define SEQ_THRESH 128
#define INSERT_THRESH 10

void insertion_sort(int *a, int left, int right)
{
  for(int i = left; i <= right; ++i)
  {
    for(int j = i; j > left && a[j-1] >= a[j]; --j)
    {
      swap(&a[j], &a[j-1]);
    }
  }
}


int partition(int* a, int left, int right) {

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

  return swapIdx;
}

void quicksort_par(int *a, int left, int right)
{

  if(right - left <= INSERT_THRESH)
  {
    insertion_sort(a, left, right);
    return;
  }


  int swapIdx = partition(a, left, right);

  #pragma omp task firstprivate(a, left, swapIdx) untied final(swapIdx - 1 - left < SEQ_THRESH)
  quicksort_par(a, left, swapIdx - 1);


  #pragma omp task firstprivate(a, swapIdx, right) untied final(right - 1 - swapIdx < SEQ_THRESH)
  quicksort_par(a, swapIdx + 1, right);

  #pragma omp taskwait
}


void quicksort(int *a, int left, int right, int num_threads) {

  //printf("num threads = %d\n", num_threads);
  omp_set_num_threads(num_threads);
  omp_set_nested(1);
  #pragma omp parallel
  {
    #pragma omp single nowait
    quicksort_par(a, left, right);
  }
}
