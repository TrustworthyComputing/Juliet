#include <tfhe/tfhe.h>
#include <tfhe/tfhe_io.h>
#include "filenames.h"


int main(int argc, char **argv) {

    seed_randomness();
    FILE* ctxt_mem = fopen("../cloud_enc/tapes/priv.txt", "w");
    char* fileName = (char*) malloc(50);

    // import private key
    FILE* secret_key = fopen("super_secret.key", "rb");
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);

    // get embedded params
    const TFheGateBootstrappingParameterSet* params = key->params;

    const char* directory = "../cloud_enc/";

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
      size_t fname_len = strlen(directory) + strlen(fileName) + 1;
      char* full_fname = (char*)malloc(fname_len);
      strcpy(full_fname, directory); // Copy the first part
      strcat(full_fname, fileName); // Concatenate the second part
      FILE* answer_data = fopen(full_fname,"wb");
      for (int i=0; i<wordSize; i++)
          export_gate_bootstrapping_ciphertext_toFile(answer_data, &ctxt[i], params);
      fclose(answer_data);
      // export ciphertext filename to aux tape index
      fprintf(ctxt_mem, "%s", fileName);
      fprintf(ctxt_mem, "\n");
      free(full_fname);
    }

    fclose(ctxt_mem);

    // free memory
    free(fileName);
    delete_gate_bootstrapping_ciphertext_array(wordSize, ctxt);
    delete_gate_bootstrapping_secret_keyset(key);
}
