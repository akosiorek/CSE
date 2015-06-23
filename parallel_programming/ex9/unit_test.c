#include <time.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mpi.h>

#include "gol.h"
#include "helper.h"
#include "gol_ref.h"

int np, rank;

int main(int argc, char *argv[])
{
    unsigned int dim_x = 83, dim_y = 41, time_steps = 160, num_threads = 3;

    unsigned char *grid = NULL; int exit_status = EXIT_FAILURE;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &np);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    size_t size = sizeof(unsigned char) * dim_x * dim_y;
    unsigned char *grid_ref = calloc(sizeof(unsigned char), dim_x * dim_y);

    if (rank == 0)
    {

        grid = calloc(sizeof(unsigned char), dim_x * dim_y);

        if (grid == NULL)
            exit(EXIT_FAILURE);

        r_pentomino(grid, dim_x, dim_y, dim_x / 2, dim_y / 2);

        if (grid_ref == NULL)
            exit(EXIT_FAILURE);

        memset(grid_ref, 0, size);
        r_pentomino(grid_ref, dim_x, dim_y, dim_x / 2, dim_y / 2);
    }

    for (int i = 0; i < time_steps; ++i)
    {
        gol(grid, dim_x, dim_y, 1);

        if (rank == 0)
        {

            gol_ref(grid_ref, dim_x, dim_y, 1, num_threads);


            if (compare_grids(grid, grid_ref, dim_x, dim_y))
            {
                fprintf(stderr, "Pattern does not match in time_step %d -- dim_x = %u dim_y = %u\n\n", i + 1, dim_x, dim_y);

                fprintf(stderr, "Your Output:\n\n");

                print_gol(grid, dim_x, dim_y);

                fprintf(stderr, "\nExpected Output:\n\n");

                print_gol(grid_ref, dim_x, dim_y);

                exit_status = EXIT_FAILURE;
            }
            else
            {
                exit_status = EXIT_SUCCESS;
            }
        }

        MPI_Bcast(&exit_status, 1, MPI_INT, 0, MPI_COMM_WORLD);

        if (exit_status == EXIT_FAILURE)
            break;
    }

    if (rank == 0)
    {
        printf("Unit test completed successfully.\n");
        free(grid);
        free(grid_ref);

    }

    MPI_Finalize();

    return exit_status;
}
