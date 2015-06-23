#ifndef HELPER_H_
#define HELPER_H_

#define STR_EXPAND(tok) #tok
#define STR(tok) STR_EXPAND(tok)

#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))
#define MAX(X,Y) ((X) > (Y) ? (X) : (Y))

int str_cmatch(const char* a, const char* b);
struct timespec ts_diff(struct timespec a, struct timespec b);
double ts_to_double(struct timespec time);
int AlmostEqualRelative(double A, double B, double maxRelDiff);
void print_gol(unsigned char *grid, unsigned int dim_x, unsigned int dim_y);
void r_pentomino(unsigned char *grid, unsigned int dim_x, unsigned int dim_y, unsigned int x, unsigned int y);
unsigned int compare_grids(unsigned char *grid, unsigned char *grid_ref, unsigned int dim_x, unsigned int dim_y);
unsigned int cells_alive(unsigned char *grid, unsigned int dim_x, unsigned int dim_y);
void evolve(unsigned char *grid_in, unsigned char *grid_out, unsigned int dim_x, unsigned int dim_y, unsigned int x, unsigned int y);
void swap(void **a, void **b);


#endif /* HELPER_H_ */
