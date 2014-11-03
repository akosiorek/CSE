/*
 * test2.cpp
 *
 *  Created on: Oct 24, 2014
 *      Author: Adam Kosiorek
 */
#include <iostream>
#include <cmath>
#include <mpi.h>
#include <cstdlib>

/**
 * Simple MPI Test
 * Integrates a function according to the trapezoidal rule
 * reduces workers' outputs by iterating MPI_Recv routines
 */


double f1(double x) {

	return 3 * ( x * x + 1);
}

double f2(double x) {

	return x * sin(10 * x);
}

double integrate(double(*f)(double), double a, double b, int n) {

	double interval = (b - a) / n;
	double value = (f(a) + f(b)) / 2;

	while(a < b) {
		a += interval;
		value += f(a);
	}
	return value * interval;
}


int main(int argc, char** argv) {

	int taskID, numproc;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numproc);
	MPI_Comm_rank(MPI_COMM_WORLD, &taskID);

	double time;

	double a = 1;
	double b = 10;
	int steps;
	double interval = (b - a) / numproc;

	b = a + interval;
	if(taskID == 0) {
		time = MPI_Wtime();
		steps = 10000;

		for(int i = 1; i < numproc; ++i) {
			MPI_Send(&steps, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
			MPI_Send(&b, 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD);
			b += interval;
			MPI_Send(&b, 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD);
		}

		b = a + interval;

	} else {
		MPI_Recv(&steps, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
		MPI_Recv(&a, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
		MPI_Recv(&b, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
	}

	std::cout << "proc #" << taskID << " Integrating on (" << a << ", " << b << ") Partial result = ";
	double partial_value = integrate(f1, a, b, steps);
	std::cout << partial_value << std::endl;

	if(taskID == 0) {
		double value = partial_value;
		for(int i = 1; i < numproc; ++i) {
			MPI_Recv(&partial_value, 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD, &status);
			value += partial_value;
		}

		std::cout << "Value = " << value << std::endl;
		std::cout << "Took: " << MPI_Wtime() - time << std::endl;
	} else {
		MPI_Send(&partial_value, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
	}

	MPI_Finalize();

	return 0;
}



