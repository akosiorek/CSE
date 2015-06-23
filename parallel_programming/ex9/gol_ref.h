#ifndef GOL_REF_H_
#define GOL_REF_H_

unsigned int gol_ref(unsigned char *grid, unsigned int dim_x, unsigned int dim_y, unsigned int time_steps, unsigned int num_threads);
void evolve_ref(unsigned char *grid_in, unsigned char *grid_out, unsigned int dim_x, unsigned int dim_y, unsigned int x, unsigned int y);
void swap_ref(unsigned char **a, unsigned char **b);
unsigned int cells_alive_ref(unsigned char *grid, unsigned int dim_x, unsigned int dim_y);

#endif /* GOL_REF_H_ */
