#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <sys/types.h>
#include "cufhe/include/cufhe_gpu.cuh"
#include "cufhe/include/cufhe.h"
#include "cufhe/include/cufhe_core.h"
#include <iostream>
#include <fstream>
#include <string>
#include <sys/stat.h>

using namespace cufhe;
using namespace std;

bool exists(const string& name) {
  struct stat buffer;
  return (stat (name.c_str(), &buffer) == 0);
}

string gen_filename()
{
  srand(time(0));
  bool isTaken = 1;
  char* fileName = (char*) malloc(28);
  while (isTaken != 0) {
      strcpy(fileName, "");
      strcpy(fileName, "encrypted_data/ctxt");
      int num = (rand() % 8999) + 1000;
      char strNum[sizeof(num)];
      sprintf(strNum, "%d", num);
      strcat(fileName, strNum);
      strcat(fileName, ".data\0");
      string strFileName(fileName, 28);
      isTaken = exists(strFileName);
  }
  string strFileName(fileName, 28);
  return strFileName;
}

int main(int argc, char **argv) {

    ofstream ctxt_mem;
    ctxt_mem.open("priv.txt");
    string fileName;

    // import private key
    PriKey key;
    ReadPriKeyFromFile(key, "super_secret.key");

    int wordSize = atoi(argv[2]);
    FILE* ptxt_vals = fopen(argv[1], "r");
    Ctxt* ctxt = new Ctxt[wordSize];
    Ptxt* ptxt = new Ptxt[wordSize];
    char line[60];

    while (fgets(line, sizeof(line), ptxt_vals) != NULL) {
      int64_t plaintext1 = atoi(line);
      for (int i=0; i<wordSize; i++) {
        ptxt[i].message_ = (plaintext1>>i)&1;
        Encrypt(ctxt[i], ptxt[i], key);
      }
      fileName = gen_filename();
      for (int i=0; i<wordSize; i++) {
          WriteCtxtToFile(ctxt[i], fileName);
      }
      // export ciphertext filename to aux tape index
      ctxt_mem << fileName;
      ctxt_mem << "\n";
    }

    ctxt_mem.close();

    // free memory
    delete [] ptxt;
    delete [] ctxt;
}
