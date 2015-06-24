#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <mpi.h>
#include <math.h>

#include "helper.h"

int z = 0;
//#define LOG(x) printf("Rank: %d, i: %d, %s: %d\n", rank, z++, #x, x); 
#define LOG(x)

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

	if(np > dim_y) {
		np = dim_y;
	}

	int proc_prev = rank == 0 ? np - 1 : rank - 1;
	int proc_next = (rank + 1) % np;
	LOG(proc_prev);
	LOG(proc_next);	

	int rowsPerProc = dim_y / np;
	int remainderRows = dim_y % np;

	rowsPerProc += remainderRows > rank;
	LOG(rowsPerProc);

	int offset = dim_x ;
	int size = dim_x * rowsPerProc;
	int bytes = (2 * offset + size) * sizeof(uchar);

	uchar* grid_in = malloc(bytes);
        uchar* grid_out = malloc(bytes);


	int* counts = NULL;
	int* displacement = NULL;

	if(rank == 0) {
		 counts = malloc(np * sizeof(*counts));
		 displacement = malloc(np * sizeof(*displacement));

		int rows = dim_y / np;
		for(int i = 0; i < np; ++i) {
			counts[i] = rows + (remainderRows > 0);
                        counts[i] *= dim_x * sizeof(uchar);
			--remainderRows;
		}

		displacement[0] = 0;
		for(int i = 1; i < np; ++i) {
			displacement[i] = displacement[i - 1] + counts[i - 1];
		}

		//for(int i = 0; i < np; ++i) {
		//	printf("count: %d, disp: %d\n", counts[i], displacement[i]);
		//}
	}

	MPI_Scatterv(	grid,	// send buffer
			counts,
			displacement,
			MPI_CHAR,
			grid_in, // begin of true data
			size,
			MPI_CHAR,
			0,	// root
			MPI_COMM_WORLD);




	MPI_Status status;
	for (int t = 0; t < time_steps; ++t)
	{
		LOG(proc_prev);
		LOG(proc_next);
		MPI_Sendrecv(	grid_in,	// send buf
				dim_x,		// send count
				MPI_CHAR, 	// send type
				proc_prev,	// destination
				0,		// send tag
				grid_in + size, //recv buff
				dim_x,		// recv count
				MPI_CHAR,	// recv type
				proc_next,	// source
				0,		// recv tag
				MPI_COMM_WORLD,	// communicator
				&status);	// status


		MPI_Sendrecv(	grid_in + size - dim_x,	// send buf
				dim_x,		// send count
				MPI_CHAR, 	// send type
				proc_next,	// destination
				0,		// send tag
				grid_in + size + offset, //recv buff
				dim_x,		// recv count
				MPI_CHAR,	// recv type
				proc_prev,	// source
				0, 		// recv tag
				MPI_COMM_WORLD,	// communicator
				&status);	// status


	//printf("Rank: %d\n", rank);
	//print_gol(grid_in, dim_x, rowsPerProc + 2);



		for (int y = 0; y < rowsPerProc; ++y)
		{
			for (int x = 0; x < dim_x; ++x)
			{
				evolve(grid_in, grid_out, dim_x, rowsPerProc + 2, x, y);
			}
		}
		swap((void**)&grid_in, (void**)&grid_out);
	}

	MPI_Gatherv(	grid_in,
			size,
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

	int alive = 0;
	if(rank == 0) {
		alive = cells_alive(grid, dim_x, dim_y);
	}
	return alive;
}

