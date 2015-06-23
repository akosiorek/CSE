#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "helper.h"

unsigned int gol(unsigned char *grid, unsigned int dim_x, unsigned int dim_y, unsigned int time_steps)
{
	unsigned char *grid_in, *grid_out, *grid_tmp;
	size_t size = sizeof(unsigned char) * dim_x * dim_y;

	grid_tmp = calloc(sizeof(unsigned char), dim_y * dim_x);
	if (grid_tmp == NULL)
		exit(EXIT_FAILURE);


	grid_in = grid;
	grid_out = grid_tmp;

	for (int t = 0; t < time_steps; ++t)
	{
		for (int y = 0; y < dim_y; ++y)
		{
			for (int x = 0; x < dim_x; ++x)
			{
				evolve(grid_in, grid_out, dim_x, dim_y, x, y);
			}
		}
		swap((void**)&grid_in, (void**)&grid_out);
	}

	if (grid != grid_in)
		memcpy(grid, grid_in, size);

	free(grid_tmp);

	return cells_alive(grid, dim_x, dim_y);
}
