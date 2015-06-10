
void compute(unsigned long **a, unsigned long **b, unsigned long **c, unsigned long **d, int N, int num_threads) {

	// perform loop alignment to transform this loop and parallelize it with OpenMP
	for (int i = 1; i < N; i++) {
		for (int j = 1; j < N; j++) {
			a[i][j] = 3 * b[i][j];
			b[i][j + 1] = c[i][j] * c[i][j];
			c[i][j - 1] = a[i][j] * d[i][j];
		}
	}
}
