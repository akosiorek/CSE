/*
 * tutorial4_ex5.cpp
 *
 *  Created on: Nov 7, 2014
 *      Author: Adam Kosiorek
 */

#include <iostream>
#include <mpi.h>

int main(int argc, char** argv) {

	int taskID, numProc;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &taskID);
	MPI_Comm_size(MPI_COMM_WORLD, &numProc);



	MPI_Finalize();
	return 0;
}


