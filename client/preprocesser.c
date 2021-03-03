#include <tfhe/tfhe.h>
#include <tfhe/tfhe_io.h>
#include "filenames.h"


int main(int argc, char **argv) {

    FILE* ctxt_mem = fopen("priv.txt", "w");
    char* fileName = (char*) malloc(50);

    // import private key
    FILE* secret_key = fopen("super_secret.key", "rb");
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);

    // get embedded params
    const TFheGateBootstrappingParameterSet* params = key->params;

    int wordSize = atoi(argv[2]);
    FILE* ptxt_vals = fopen(argv[1], "r");
    LweSample* ctxt = new_gate_bootstrapping_ciphertext_array(wordSize, params);
    char line[60];
    while (fgets(line, sizeof(line), ptxt_vals) != NULL) {
      int64_t plaintext1 = atoi(line);
      for (int i=0; i<wordSize; i++) {
        bootsSymEncrypt(&ctxt[i], (plaintext1>>i)&1, key);
      }
      fileName = gen_filename();
      FILE* answer_data = fopen(fileName,"wb");
      for (int i=0; i<wordSize; i++)
          export_gate_bootstrapping_ciphertext_toFile(answer_data, &ctxt[i], params);
      fclose(answer_data);
      // export ciphertext filename to aux tape index
      fprintf(ctxt_mem, "%s", fileName);
      fprintf(ctxt_mem, "\n");
    }

    fclose(ctxt_mem);

    // free memory
    free(fileName);
    delete_gate_bootstrapping_ciphertext_array(wordSize, ctxt);
    delete_gate_bootstrapping_secret_keyset(key);
}
