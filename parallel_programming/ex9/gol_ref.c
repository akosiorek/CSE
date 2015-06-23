#include <stdlib.h>
#include <string.h>
#include "helper.h"
#include "gol_ref.h"
#include "gol.h"

void evolve_ref(unsigned char *grid_in, unsigned char *grid_out, unsigned int dim_x, unsigned int dim_y, unsigned int x, unsigned int y)
{
	unsigned char (*c_grid_in)[dim_x] = (unsigned char (*)[dim_x])grid_in;
	unsigned char (*c_grid_out)[dim_x] = (unsigned char (*)[dim_x])grid_out;

	unsigned int num_neighbors = 0;

	num_neighbors += c_grid_in[(y + dim_y - 1) % dim_y][(x + dim_x - 1) % dim_x];
	num_neighbors += c_grid_in[(y + dim_y - 1) % dim_y][(x + dim_x - 0) % dim_x];
	num_neighbors += c_grid_in[(y + dim_y - 1) % dim_y][(x + dim_x + 1) % dim_x];

	num_neighbors += c_grid_in[(y + dim_y - 0) % dim_y][(x + dim_x - 1) % dim_x];
	num_neighbors += c_grid_in[(y + dim_y + 0) % dim_y][(x + dim_x + 1) % dim_x];

	num_neighbors += c_grid_in[(y + dim_y + 1) % dim_y][(x + dim_x - 1) % dim_x];
	num_neighbors += c_grid_in[(y + dim_y + 1) % dim_y][(x + dim_x - 0) % dim_x];
	num_neighbors += c_grid_in[(y + dim_y + 1) % dim_y][(x + dim_x + 1) % dim_x];


	unsigned int table[][9] = {
    // dead cell                 0, 1, 2, 3, 4, 5, 6, 7, 8
			                   { 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	// living cell               0, 1, 2, 3, 4, 5, 6, 7, 8
			                   { 0, 0, 1, 1, 0, 0, 0, 0, 0 }
	                         };

	c_grid_out[y][x] = table[c_grid_in[y][x]][num_neighbors];
}

void swap_ref(unsigned char **a, unsigned char **b)
{
	unsigned char *tmp = *a;
	*a = *b;
	*b = tmp;
}

unsigned int cells_alive_ref(unsigned char *grid, unsigned int dim_x, unsigned int dim_y)
{
	unsigned char (*c_grid)[dim_x] = (unsigned char (*)[dim_x])grid;

	unsigned int cells = 0;

	for (int y = 0; y < dim_y; ++y)
	{
		for (int x = 0; x < dim_x; ++x)
		{
			cells += c_grid[y][x];
		}
	}

	return cells;
}

unsigned int gol_ref(unsigned char *grid, unsigned int dim_x, unsigned int dim_y, unsigned int time_steps, unsigned int num_threads)
{
	unsigned char *grid_in, *grid_out, *grid_tmp;
	size_t size = sizeof(unsigned char) * dim_x * dim_y;

	grid_tmp = malloc(size);
	if(grid_tmp == NULL)
		exit(EXIT_FAILURE);

	memset(grid_tmp, 0, size);

	grid_in = grid;
	grid_out = grid_tmp;

	for (int t = 0; t < time_steps; ++t)
	{
		for (int y = 0; y < dim_y; ++y)
		{
			for (int x = 0; x < dim_x; ++x)
			{
				evolve_ref(grid_in, grid_out, dim_x, dim_y, x, y);
			}
		}
		swap_ref(&grid_in, &grid_out);
	}

	if(grid != grid_in)
		memcpy(grid, grid_in, size);

	free(grid_tmp);

	return cells_alive_ref(grid, dim_x, dim_y);
}
