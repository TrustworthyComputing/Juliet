#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include "cufhe/include/cufhe_gpu.cuh"
#include "cufhe/include/cufhe.h"
#include "cufhe/include/cufhe_core.h"

using namespace std;
using namespace cufhe;

int main(int argc, char** argv) {

    printf("Generating secure random keyset with 110 bits of security...\n");

    // generate keypair
    PriKey secret_key;
    PubKey public_key;
    PriKeyGen(secret_key);
    PubKeyGen(public_key, secret_key);

    // export secret key to file
    WritePriKeyToFile(secret_key, "super_secret.key");

    // export cloud key to file
    WritePubKeyToFile(public_key, "../cloud_enc/clouds.key");

    printf("Finished exporting!\n");

    return 0;
}
