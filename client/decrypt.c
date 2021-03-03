#include <tfhe/tfhe.h>
#include <tfhe/tfhe_io.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char** argv) {

    //reads the secret key from file
    FILE* secret_key = fopen("super_secret.key","rb");
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);

    //if necessary, the params are inside the key
    const TFheGateBootstrappingParameterSet* params = key->params;

    //read the 8 ciphertexts of the result
    int wordSize = atoi(argv[2]);

    LweSample* answer = new_gate_bootstrapping_ciphertext_array(wordSize, params);

    FILE* answer_data = fopen(argv[1],"rb");
    for (int i=0; i<wordSize; i++)
        import_gate_bootstrapping_ciphertext_fromFile(answer_data, &answer[i], params);
    fclose(answer_data);

    //decrypt and rebuild the answer
    int int_answer = 0;
    for (int i=0; i<wordSize; i++) {
        int ai = bootsSymDecrypt(&answer[i], key)>0;
        int_answer |= (ai<<i);
    }

    //clean up all pointers
    delete_gate_bootstrapping_ciphertext_array(wordSize, answer);
    delete_gate_bootstrapping_secret_keyset(key);

    printf("Decrypted Answer: %d\n", int_answer);
    return int_answer;
}
