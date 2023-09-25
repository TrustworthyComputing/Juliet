#include <tfhe/tfhe.h>
#include <tfhe/tfhe_io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {

    //generate a keyset
    const int minimum_lambda = 110;
    TFheGateBootstrappingParameterSet* params = new_default_gate_bootstrapping_parameters(minimum_lambda);

    // read 12 bytes from /dev/urandom
    FILE* urandom = fopen("/dev/urandom", "r");
    char rdata[13];
    fread(&rdata, 1, 12, urandom);
    rdata[12] = '\0';
    fclose(urandom);

    // convert bytes to integers
    uint32_t data1 = rdata[0] | ( (int)rdata[1] << 8 ) | ( (int)rdata[2] << 16 ) | ( (int)rdata[3] << 24 );
    uint32_t data2 = rdata[4] | ( (int)rdata[5] << 8 ) | ( (int)rdata[6] << 16 ) | ( (int)rdata[7] << 24 );
    uint32_t data3 = rdata[8] | ( (int)rdata[9] << 8 ) | ( (int)rdata[10] << 16 ) | ( (int)rdata[11] << 24 );

    //generate a random key
    uint32_t seed[] = { data1, data2, data3 };
    tfhe_random_generator_setSeed(seed,3);
    TFheGateBootstrappingSecretKeySet* key = new_random_gate_bootstrapping_secret_keyset(params);

    // export secret key to file
    FILE* secret_key = fopen("super_secret.key", "wb");
    export_tfheGateBootstrappingSecretKeySet_toFile(secret_key, key);
    fclose(secret_key);


    // export cloud key to file
    FILE* cloud_key = fopen("../cloud_enc/clouds.key", "wb");
    export_tfheGateBootstrappingCloudKeySet_toFile(cloud_key, &key->cloud);
    fclose(cloud_key);

    delete_gate_bootstrapping_secret_keyset(key);
}
