#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "quicksort.h"
#include "helper.h"

void quicksort(int *a, int left, int right, int num_threads)
{
	if(left < right)
	{
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

	  quicksort(a, left, swapIdx - 1, num_threads);
	  quicksort(a, swapIdx + 1, right, num_threads);

	}
}