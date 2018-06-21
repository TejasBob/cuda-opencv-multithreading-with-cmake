#include <iostream>
#include<thread>

using namespace std;

void f1(){
  printf("model thread part 2 completed\n");
}

void f2(){
  printf("Tile thread completed\n");
}

void f3(){
  printf("stream thread finished\n");
}

void f4(){
  printf("inference thread started, .... finished\n");
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
int main(){
  master();
  getchar();
  return 0;
}


