#include <iostream>
#include<thread>
#include "cuda_runtime.h"
#include "../header/gpu.hpp"

#include<opencv2/core/core.hpp>
#include<opencv2/imgcodecs.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace cv;


using namespace std;

__global__ void kernel0()
{
	printf("hello world! -> 0\n");
}

__global__ void kernel1()
{
	printf("hello world! -> 1\n");
}

__global__ void kernel2()
{
	printf("hello world! -> 2\n");
}

__global__ void kernel3()
{
	printf("hello world! -> 3\n");
}



void f1(){
	int err = cudaSetDevice(0);
        printf("set device 0  %d \n", err);
	kernel0 << <1, 1 >> >();
        cudaDeviceSynchronize();
}

void f2(){
	int err = cudaSetDevice(1);
	printf("set device 1  %d \n", err);
	kernel1 << <1, 1 >> >();
        cudaDeviceSynchronize();
}

void f3(){
	int err = cudaSetDevice(2);
	printf("set device 2  %d \n", err);
	kernel2 << <1, 1 >> >();
        cudaDeviceSynchronize();
}

void f4(){
	int err = cudaSetDevice(3);
	printf("set device 3  %d \n", err);
	kernel3 << <1, 1 >> >();
        cudaDeviceSynchronize();
}


void master(){

  thread model_thread(f1);
  thread tile_thread(f2);
  thread stream_thread(f3);

  model_thread.join();
  tile_thread.join();
  stream_thread.join();

  thread dl_thread(f4);
  dl_thread.join();

  printf("waiting for master thread to return\n");

  


}

void printCudaVersion(){
printf("somewhere here\n");
  int err = cudaSetDevice(0);
  master();
  cudaDeviceSynchronize();
  Mat image = imread("/home/joker/cmake-cuda-example-master/cat.jpg", -1);
  imshow("image", image);
  waitKey(0);
//  return 0;
}

/*
int main()
{
printCudaVersion();
return 0;

}
*/
