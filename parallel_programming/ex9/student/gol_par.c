#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "helper.h"

unsigned int gol(unsigned char *grid, unsigned int dim_x, unsigned int dim_y, unsigned int time_steps)
{
	// READ ME! Parallelize this function to work with MPI. It must work even with a single processor.
	// We expect you to use MPI_Scatterv, MPI_Gatherv, and MPI_Sendrecv to achieve this.
	// MPI_Scatterv/Gatherv are checked to equal np times, and MPI_Sendrecv is expected to equal 2 * np * timesteps
	// That is, top+bottom ghost cells * all processors must execute this command * Sendrecv executed every timestep.
	typedef unsigned char uchar;

	int np, rank;
	MPI_Comm_size(MPI_COMM_WORLD, &np);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if(rank >= dim_y) {
		return 0;
        }

	np = min(np, dim_y);

	size_t rowsPerProc = dim_y / np;
	size_t remainderRows = dim_y % np;

	rowsPerProc += remainderRows > rank;


	size_t size = dim_x * (rowsPerProc + 2);
	size_t bytes = size * sizeof(uchar);
	size_t offset = dim_x * sizeof(uchar);

	uchar* grid_in = malloc(bytes);
        uchar* grid_out = malloc(bytes);


	int* counts = NULL;
	int* displacment = NULL;

	if(rank == 0) {
		 counts = malloc(np * sizeof(*counts));
		 displacment = malloc(np * sizeof(*displacement));

		for(int i = 0; i < np; ++i) {
			counts[i] = rowsPerProc + (remainderRows > 0);
                        counts[i] *= dim_x * sizeof(uchar);
			--remainderRows;
		}

		displacement[0] = 0;
		for(int i = 1; i < np; ++i) {
			displacement[i] = displacement[i - 1] + counts[i - 1];
		}
	}

	MPI_Scatterv(	grid,	// send buffer
			counts,
			displacement,
			MPI_CHAR,
			buffer + offset, // begin of true data
			MPI_CHAR,
			0,	// root
			MPI_COMM_WORLD);


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

	if(rank == 0) {
		size_t totalSize = dim_x * dim_y;
		for(int i = 0; i < np; ++i) {
			displacement[i] = totalSize - displacement[i] - counts[i];
		}
	}

	MPI_Gatherv(	buffer,
			bufferSize,
			MPI_CHAR,
			grid,
			counts,
			displacement,
			MPI_CHAR,
			0,
			MPI_COMM_WORLD);

	free(grid_in);
	free(grid_out);

	if(rank == 0) {
		free(counts);
		free(displacement);
	}

	return cells_alive(grid, dim_x, dim_y);
}
