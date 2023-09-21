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

using namespace cufhe;
using namespace std;

int main(int argc, char** argv) {

    // import private key
    PriKey key;
    ReadPriKeyFromFile(key, "super_secret.key");

    //read the ciphertexts of the result
    int wordSize = atoi(argv[2]);
    Ctxt* answer = new Ctxt[wordSize];
    ifstream answer_data(argv[1]);
    for (int i=0; i<wordSize; i++)
        ReadCtxtFromFile(answer[i], answer_data);

    answer_data.close();

    //decrypt and rebuild the answer
    Ptxt* pt_answer = new Ptxt[wordSize];
    int int_answer = 0;
    for (int i=0; i<wordSize; i++) {
        Decrypt(pt_answer[i], answer[i], key);
        int_answer |= (pt_answer[i].message_<<i);
    }

    printf("Decrypted Answer (Int): %d\n", int_answer);
    printf("Decrypted Answer (Bin): ");
    for (int i = 0; i <wordSize; i++) {
        printf("%d", pt_answer[i].message_);
    }
    printf("\n");

    //clean up all pointers
    delete [] answer;
    delete [] pt_answer;
    
    return int_answer;
}
