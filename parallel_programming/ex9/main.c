#include <time.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mpi.h>

#include "gol.h"
#include "helper.h"

int np, rank;

int main(int argc, char *argv[])
{
	unsigned int dim_x = 80, dim_y = 40, time_steps = 80;

	if (argc > 1)
		time_steps = strtoul(argv[1], NULL, 0);

	if (argc > 2)
		dim_x = strtoul(argv[2], NULL, 0);

	if (argc > 3)
		dim_y = strtoul(argv[3], NULL, 0);

	if (dim_x < 9 || dim_y < 9)
	{
		printf("Invalid dim_x / dim_y!\n");
		exit(EXIT_FAILURE);
	}

	struct timespec begin, end;
	unsigned char *grid = NULL;

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &np);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if (rank == 0)
	{
		size_t size = sizeof(unsigned char) * dim_x * dim_y;
		grid = malloc(size);

		if (grid == NULL)
			exit(EXIT_FAILURE);

		memset(grid, 0, size);

		r_pentomino(grid, dim_x, dim_y, dim_x / 2, dim_y / 2);

		printf("\nGame of Life: time_steps = %u; dim_x = %u; dim_y = %u; processes = %d \n\n", time_steps, dim_x, dim_y, np);

		if (dim_x < 100)
			print_gol(grid, dim_x, dim_y);

		printf("\n\n");

		clock_gettime(CLOCK_REALTIME, &begin);
	}

	unsigned int living_cells = gol(grid, dim_x, dim_y, time_steps);
	if (rank == 0)
	{

		clock_gettime(CLOCK_REALTIME, &end);

		if (dim_x < 100)
			print_gol(grid, dim_x, dim_y);

		printf("Living Cells after %u time steps: %u\n", time_steps, living_cells);
		printf("Time: %.3lf seconds\n", ts_to_double(ts_diff(begin, end)));

		free(grid);

	}

	MPI_Finalize();

	return 0;
}
