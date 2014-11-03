/*
 * tutorial3_ex5.cpp
 *
 *  Created on: Nov 1, 2014
 *      Author: Adam Kosiorek
 */

#include <iostream>
#include <mpi.h>
#include <random>
#include <functional>
#include <algorithm>

#define SUM

const int problemSize = (int)10e6;

void generateRandomNumbers(float* vec, int problemSize) {

	static std::random_device rd;
	static std::mt19937 randomGenerator;
	randomGenerator.seed(rd());
	static std::uniform_real_distribution<float> distribution(0, 1);
	std::generate(vec, vec + problemSize, std::bind(distribution, randomGenerator));
}

void sum(float* a, float* b, int size) {
	std::transform(a, a + size, b, a, [](float e1, float e2) mutable {
		return e1 + e2;
	});
}

void multiply(float* a, float* b, int size) {
	std::transform(a, a + size, b, a, [](const float e1, const float e2) {
		return e1 * e2;
	});
}

template<class T>
void printVec(const std::vector<T>& vec) {
	if(problemSize > 100) {
		return;
	}
	for(auto v : vec) {
		std::cout << v << " ";
	}
	std::cout << std::endl;
}

template<class T>
void printVec(T* vec, int size) {
	if(problemSize > 100) {
			return;
	}
	T* end = vec + size;
	while(vec < end) {
		std::cout << *vec++ << " ";
	}
	std::cout << std::endl;
}

int main(int argc, char** argv) {

	int taskID, numProc;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numProc);
	MPI_Comm_rank(MPI_COMM_WORLD, &taskID);

	int sizePerCore = problemSize / numProc;
	float* A = new float[sizePerCore];
	float* B = new float[sizePerCore];
	float* a = nullptr;
	float* b = nullptr;

	double start;

	if(taskID == 0) {
		a = new float[problemSize];
		b = new float[problemSize];
		generateRandomNumbers(a, problemSize);
		generateRandomNumbers(b, problemSize);

		std::cout << "a:" << std::endl;
		printVec(a, problemSize);
		std::cout << "b:" << std::endl;
		printVec(b, problemSize);

		start = MPI_Wtime();
	}

	MPI_Scatter(a, sizePerCore, MPI_FLOAT, A, sizePerCore, MPI_FLOAT, 0, MPI_COMM_WORLD);
	MPI_Scatter(b, sizePerCore, MPI_FLOAT, B, sizePerCore, MPI_FLOAT, 0, MPI_COMM_WORLD);

#ifdef SUM
	sum(A, B, sizePerCore);
	MPI_Gather(A, sizePerCore, MPI_FLOAT, a, sizePerCore, MPI_FLOAT, 0, MPI_COMM_WORLD);

	if(taskID == 0) {
		std::cout << "Sum result:" << std::endl;
		printVec(a, problemSize);
	}

#else
	multiply(A, B, sizePerCore);
	float* result = nullptr;
	if(taskID == 0) {
		result = new float[sizePerCore];
	}
	MPI_Reduce(A, result, sizePerCore, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);

	if(taskID == 0) {
		float r = 0;
		for(int i = 0; i < sizePerCore; ++i) {
			r += result[i];
		}
		std::cout << "Dot result = " << r << std::endl;

		delete[] result;
	}
#endif

	if(taskID == 0) {
		std::cout << "Took " << MPI_Wtime() - start << " s" << std::endl;
		delete[] a;
		delete[] b;
	}

	delete[] A;
	delete[] B;

	MPI_Finalize();

	return 0;
}

