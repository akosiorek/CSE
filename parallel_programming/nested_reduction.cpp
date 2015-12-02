#include <omp.h>
#include <iostream>

using namespace std;

int main(int argc, char** argv) {


	int a[10][10];
	int b[10]  = {0};

	for(int i = 0; i < 10; ++i) {
		for(int j = 0; j < 10; ++j) {
			a[i][j] = i * 10 + j;
		}
	}


#pragma omp parallel for
	for(int i = 0; i < 10; ++i) {

#pragma omp for reduction(+: b[i]) nowait
		for(int j = 0; j < 10; ++j) {
			b[i] += a[i][j];
		}
	}
	
	for(int i = 0; i < 10; ++i) {
		cout << b[i] << ", ";
        }
        cout << endl;
}
