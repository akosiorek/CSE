/*
 * tutorial4_ex4.cpp
 *
 *  Created on: Nov 7, 2014
 *      Author: Adam Kosiorek
 */

#include <iostream>
#include <mpi.h>

//#define BLOCKING

MPI_Request send(int* buf, int n, int to) {

	MPI_Request request;
#ifdef BLOCKING
		MPI_Send(buf, n, MPI_INT, to, 0, MPI_COMM_WORLD);
#else
		MPI_Isend(buf, n, MPI_INT, to, 0, MPI_COMM_WORLD, &request);
#endif
		return request;
}

MPI_Request receive(int* buf, int n, int from) {

	MPI_Request request;
	MPI_Status status;
#ifdef BLOCKING
		MPI_Recv(buf, n, MPI_INT, from, 0, MPI_COMM_WORLD, &status);
#else
		MPI_Irecv(buf, n, MPI_INT, from, 0, MPI_COMM_WORLD, &request);
#endif
		return request;
}

int main(int argc, char** argv) {

	int taskID, numProc;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numProc);
	MPI_Comm_rank(MPI_COMM_WORLD, &taskID);

	if(taskID == 0) {

		int a = 0;
		MPI_Request request = send(&a, 1, 1);

		a = 1;
#ifndef BLOCKING
//		MPI_Wait(&request, &status);
		MPI_Barrier(MPI_COMM_WORLD);
#endif
		send(&a, 1, 1);

	} else {

		int b = -1;
		receive(&b, 1, 0);

		std::cout << b << std::endl;
#ifndef BLOCKING
		MPI_Barrier(MPI_COMM_WORLD);
#endif
		receive(&b, 1, 0);
		std::cout << b << std::endl;
	}


	MPI_Finalize();
	return 0;
}
