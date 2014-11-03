#include <iostream>
#include <cmath>
#include <mpi.h>
#include <cstdlib>

// drevangel@mytum.de

/**
 * Simple MPI test
 * Writes to std whether the process is a master or a slave
 */

int main(int argc, char** argv) {

	int taskID;
	int numproc;
	char hostname[MPI_MAX_PROCESSOR_NAME];
	int len;

	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numproc);
	MPI_Comm_rank(MPI_COMM_WORLD, &taskID);
	MPI_Get_processor_name(hostname, &len);




	if(taskID == 0) {
		std::cout << "I'm the master" << std::endl;
		int variable;
		for(int i = 1; i < numproc; ++i) {
			variable = rand();
			MPI_Send(&variable, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
			std::cout << "sent " << variable << std::endl;
		}
	} else {
		std::cout << "I'm a slave" << std::endl;
		int variable;
		MPI_Status status;
		MPI_Recv(&variable, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
		std::cout << "Received " << variable << std::endl;
	}
	MPI_Finalize();

	return 0;
}
