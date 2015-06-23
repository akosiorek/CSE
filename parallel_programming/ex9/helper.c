#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdio.h>

#define sign(x) ((x > 0) - (x < 0))

int str_cmatch(const char* a, const char* b)
{
	int i = 0;

	while (a[i] != 0 && b[i] != 0 && a[i] == b[i])
		i++;

	return i;
}

struct timespec ts_diff(struct timespec a, struct timespec b)
{
	struct timespec t;

	t.tv_sec = a.tv_sec - b.tv_sec;
	t.tv_nsec = a.tv_nsec - b.tv_nsec;

	a.tv_sec = abs(t.tv_sec) - 1 * ((sign(t.tv_sec) * sign(t.tv_nsec)) < 0);
	a.tv_nsec = abs(1000000000 * ((sign(t.tv_sec) * sign(t.tv_nsec)) < 0) - abs(t.tv_nsec));

	return a;
}

double ts_to_double(struct timespec time)
{
	return time.tv_sec + time.tv_nsec / 1e9;
}

int AlmostEqualRelative(double A, double B, double maxRelDiff)
{
	// Calculate the difference.
	double diff = fabs(A - B);
	A = fabs(A);
	B = fabs(B);
	// Find the largest
	float largest = (B > A) ? B : A;

	if (diff <= largest * maxRelDiff)
		return 1;
	return 0;
}

void print_gol(unsigned char *grid, unsigned int dim_x, unsigned int dim_y)
{
	unsigned char (*c_grid)[dim_x] = (unsigned char (*)[dim_x])grid;

	size_t size = sizeof(unsigned char) * dim_x + 4;

	unsigned char *row = malloc(size);
	if (row == NULL)
		exit(EXIT_FAILURE);

	memset(row, '-', size);
	row[0] = '+';
	row[size - 3] = '+';
	row[size - 2] = '\n';
	row[size - 1] = '\0';

	printf("%s", row);

	row[0] = '|';
	row[size - 3] = '|';

	for (int i = 0; i < dim_y; ++i) {
		for (int j = 0; j < dim_x; ++j) {
			if (c_grid[i][j] == 0)
				row[j + 1] = ' ';
			else
				row[j + 1] = '*';
		}
		printf("%s", row);
	}

	memset(row, '-', size);
	row[0] = '+';
	row[size - 3] = '+';
	row[size - 2] = '\n';
	row[size - 1] = '\0';

	printf("%s", row);

	free(row);
}

void r_pentomino(unsigned char *grid, unsigned int dim_x, unsigned int dim_y, unsigned int x, unsigned int y)
{
	unsigned char (*c_grid)[dim_x] = (unsigned char (*)[dim_x])grid;

	c_grid[(y + dim_y - 1) % dim_y][(x + dim_x - 0) % dim_x] = 1;
	c_grid[(y + dim_y - 1) % dim_y][(x + dim_x + 1) % dim_x] = 1;

	c_grid[(y + dim_y - 0) % dim_y][(x + dim_x - 1) % dim_x] = 1;
	c_grid[(y + dim_y - 0) % dim_y][(x + dim_x - 0) % dim_x] = 1;

	c_grid[(y + dim_y + 1) % dim_y][(x + dim_x - 0) % dim_x] = 1;
}

unsigned int compare_grids(unsigned char *grid, unsigned char *grid_ref, unsigned int dim_x, unsigned int dim_y)
{
	unsigned char (*c_grid)[dim_x] = (unsigned char (*)[dim_x])grid;
	unsigned char (*c_grid_ref)[dim_x] = (unsigned char (*)[dim_x])grid_ref;

	for (int y = 0; y < dim_y; ++y)
	{
		for (int x = 0; x < dim_x; ++x)
		{
			if (c_grid[y][x] != c_grid_ref[y][x])
				return EXIT_FAILURE;
		}
	}

	return EXIT_SUCCESS;
}

unsigned int cells_alive(unsigned char *grid, unsigned int dim_x, unsigned int dim_y)
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

void evolve(unsigned char *grid_in, unsigned char *grid_out, unsigned int dim_x, unsigned int dim_y, unsigned int x, unsigned int y)
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

void swap(void **a, void **b)
{
    void *tmp = *a;
    *a = *b;
    *b = tmp;
}

