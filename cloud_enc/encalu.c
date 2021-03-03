#include <tfhe/tfhe.h>
#include <tfhe/tfhe_io.h>
#include "filenames.h"
#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#define MAX 100
#define PORT 8080
#define SA struct sockaddr

// Logic Functions

// 0
void e_and(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsAND(&result[i], &a[i], &b[i], bk);
    }
}
// 1
void e_nand(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsNAND(&result[i], &a[i], &b[i], bk);
    }
}
// 2
void e_or(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsOR(&result[i], &a[i], &b[i], bk);
    }
}
// 3
void e_nor(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsNOR(&result[i], &a[i], &b[i], bk);
    }
}
// 4
void e_xor(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsXOR(&result[i], &a[i], &b[i], bk);
    }
}
// 5
void e_xnor(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsXNOR(&result[i], &a[i], &b[i], bk);
    }
}
// 9
void e_not(LweSample* result, const LweSample* a, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsNOT(&result[i], &a[i], bk);
    }
}

// 10
void e_shl(LweSample* result, const LweSample* a, const int shift_amt, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
  LweSample* temp = new_gate_bootstrapping_ciphertext_array(nb_bits, bk->params);

  for(int i = 0; i < nb_bits; i++) {
    bootsCOPY(&result[i], &a[i], bk);
  }

  for(int i = 0; i < shift_amt; i++) {
    for(int j = 1; j < nb_bits; j++) {
      bootsCOPY(&temp[j], &result[j-1], bk);
    }

    for(int k = 1; k < nb_bits; k++) {
      bootsCOPY(&result[k], &temp[k], bk);
    }

    bootsCONSTANT(&result[0], 0, bk); // set lowest bit to 0

  }

  delete_gate_bootstrapping_ciphertext_array(nb_bits, temp);
}

// 11
void e_shr(LweSample* result, const LweSample* a, const int shift_amt, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {

  LweSample* temp = new_gate_bootstrapping_ciphertext_array(nb_bits, bk->params);

  for(int i = 0; i < nb_bits; i++) {
    bootsCOPY(&result[i], &a[i], bk);
  }

  for(int i = 0; i < shift_amt; i++) {
    for(int j = 0; j < nb_bits - 1; j++) {
      bootsCOPY(&temp[j], &result[j+1], bk);
    }


    for(int k = 0; k < nb_bits; k++) {
      bootsCOPY(&result[k], &temp[k], bk);
    }

    bootsCONSTANT(&result[nb_bits - 1], 0, bk); // set highest bit to 0

  }

  delete_gate_bootstrapping_ciphertext_array(nb_bits, temp);
}

// 12
void e_mux(LweSample* result, const LweSample* sel, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {
    for (int i=0; i<nb_bits; i++) {
        bootsMUX(&result[i], &sel[0], &a[i], &b[i], bk);
    }
}

// Arithmetic Functions

// 13
void comparator(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const int select, const TFheGateBootstrappingCloudKeySet* bk) {

    LweSample* not_a = new_gate_bootstrapping_ciphertext_array(1, bk->params);
    LweSample* not_b = new_gate_bootstrapping_ciphertext_array(1, bk->params);
    LweSample* temp = new_gate_bootstrapping_ciphertext_array(10, bk->params);
    LweSample* greater_than = new_gate_bootstrapping_ciphertext_array(1, bk->params);
    LweSample* equal = new_gate_bootstrapping_ciphertext_array(1, bk->params);
    LweSample* less_than = new_gate_bootstrapping_ciphertext_array(1, bk->params);

    // initialize cascading inputs
    bootsCONSTANT(&greater_than[0], 0, bk);
    bootsCONSTANT(&less_than[0], 0, bk);
    bootsCONSTANT(&equal[0], 1, bk);


    //run 1 bit comparators
    for (int i = (nb_bits - 1); i > -1; i--) {
    //for (int i = 0; i < nb_bits; i++) {
        // invert inputs
        bootsNOT(&not_a[0], &a[i], bk);
        bootsNOT(&not_b[0], &b[i], bk);

        // compute greater than path
        bootsNOT(&temp[0], &greater_than[0], bk);
        bootsNAND(&temp[1], &a[i], &not_b[0], bk);
        bootsNAND(&temp[2], &temp[1], &equal[0], bk);
        bootsNOT(&temp[3], &temp[2], bk);
        bootsNAND(&greater_than[0], &temp[0], &temp[3], bk);
        bootsNOT(&temp[8], &less_than[0], bk);
        bootsAND(&greater_than[0], &temp[8], &greater_than[0], bk);

        // compute less than path
        bootsNOT(&temp[4], &less_than[0], bk);
        bootsNAND(&temp[5], &not_a[0], &b[i], bk);
        bootsNAND(&temp[6], &temp[5], &equal[0], bk);
        bootsNOT(&temp[7], &temp[6], bk);
        bootsNAND(&less_than[0], &temp[7], &temp[4], bk);
        bootsNOT(&temp[9], &greater_than[0], bk);
        bootsAND(&less_than[0], &temp[9], &less_than[0], bk);

        // compute equality path
        bootsNOR(&equal[0], &greater_than[0], &less_than[0], bk);

    }

    // select desired output
    if (select == 0) { // ecmpeq
        bootsCOPY(&result[0], &equal[0], bk);
    }
    else if (select == 1) { // ecmpl
        bootsCOPY(&result[0], &less_than[0], bk);
    }
    else if (select == 2) { // ecmpg
        bootsCOPY(&result[0], &greater_than[0], bk);
    }
    else if (select == 3) { // ecmpgeq
        bootsOR(&result[0], &equal[0], &greater_than[0], bk);
    }
    else if (select == 4) { // ecmpleq
        bootsOR(&result[0], &equal[0], &less_than[0], bk);
    }
    else if (select == 5) { // ecmpneq
      bootsCOPY(&result[0], &equal[0], bk);
      bootsNOT(&result[0], &result[0], bk);
    }

    // align to word size
    for (int i = 1; i < nb_bits; i++) {
        bootsCONSTANT(&result[i], 0, bk);
    }

    delete_gate_bootstrapping_ciphertext_array(1, not_a);
    delete_gate_bootstrapping_ciphertext_array(1, not_b);
    delete_gate_bootstrapping_ciphertext_array(8, temp);
    delete_gate_bootstrapping_ciphertext_array(1, greater_than);
    delete_gate_bootstrapping_ciphertext_array(1, equal);
    delete_gate_bootstrapping_ciphertext_array(1, less_than);
}
// 6
void subtracter(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {

    LweSample* borrow = new_gate_bootstrapping_ciphertext_array(nb_bits, bk->params);
    LweSample* temp = new_gate_bootstrapping_ciphertext_array(3, bk->params);

    // run half subtractor
    bootsXOR(&result[0], &a[0], &b[0], bk);
    bootsNOT(&temp[0], &a[0], bk);
    bootsAND(&borrow[0], &temp[0], &b[0], bk);

    // run full subtractors
    for (int i = 1; i < nb_bits; i++) {

      // Calculate difference
      bootsXOR(&temp[0], &a[i], &b[i], bk);
      bootsXOR(&result[i], &temp[0], &borrow[i-1], bk);

      // Calculate borrow
      bootsNOT(&temp[1], &a[i], bk);
      bootsAND(&temp[2], &temp[1], &b[i], bk);
      bootsNOT(&temp[0], &temp[0], bk);
      bootsAND(&temp[1], &borrow[i-1], &temp[0], bk);
      bootsOR(&borrow[i], &temp[2], &temp[1], bk);
    }

    delete_gate_bootstrapping_ciphertext_array(nb_bits, borrow);
    delete_gate_bootstrapping_ciphertext_array(3, temp);

}
//7
void adder(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {

    LweSample* carry = new_gate_bootstrapping_ciphertext_array(nb_bits+1, bk->params);
    LweSample* temp = new_gate_bootstrapping_ciphertext_array(1, bk->params);

    //initialize first carry to 0
    bootsCONSTANT(&carry[0], 0, bk);

    //run full adders

    for (int i = 0; i < nb_bits; i++) {

      bootsXOR(&temp[0], &a[i], &b[i], bk);

      // Compute sum
      bootsXOR(&result[i], &carry[i], &temp[0], bk);

      // Compute carry
      bootsMUX(&carry[i+1], &temp[0], &carry[i], &a[i], bk);
    }

    delete_gate_bootstrapping_ciphertext_array(nb_bits+1, carry);
    delete_gate_bootstrapping_ciphertext_array(1, temp);
}
// 8

void add_supplement(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {

  if (nb_bits == 0) {
    return;
  }
  LweSample* carry = new_gate_bootstrapping_ciphertext_array(nb_bits+1, bk->params);
  LweSample* temp = new_gate_bootstrapping_ciphertext_array(1, bk->params);

  //initialize first carry to 0
  bootsCONSTANT(&carry[0], 0, bk);

  //run full adders

  for (int i = 0; i < nb_bits; i++) {

    bootsXOR(&temp[0], &a[i], &b[i], bk);

    // Compute sum
    bootsXOR(&result[i], &carry[i], &temp[0], bk);

    // Compute carry
    bootsMUX(&carry[i+1], &temp[0], &carry[i], &a[i], bk);
  }

  delete_gate_bootstrapping_ciphertext_array(nb_bits+1, carry);
  delete_gate_bootstrapping_ciphertext_array(1, temp);

}

void multiplier(LweSample* result, const LweSample* a, const LweSample* b, const int nb_bits, const TFheGateBootstrappingCloudKeySet* bk) {

    LweSample* tmp_array = new_gate_bootstrapping_ciphertext_array(nb_bits, bk->params);
    LweSample* sum = new_gate_bootstrapping_ciphertext_array(nb_bits, bk->params);

    for (int i = 0; i < nb_bits; ++i) {
        // initialize temp values to 0
        bootsCONSTANT(&sum[i], 0, bk);
        bootsCONSTANT(&result[i], 0, bk);
    }

    for (int i = 0; i < nb_bits; ++i) {
        for (int k = 0; k < nb_bits; ++k) {
            bootsCONSTANT(&tmp_array[k], 0, bk);
        }
        for (int j = 0; j < nb_bits - i; ++j) {
            bootsAND(&tmp_array[j], &a[i], &b[j], bk);
        }
        add_supplement(sum + i, tmp_array, sum + i, nb_bits - i, bk);
    }

    for (int j = 0; j < nb_bits; j++) {
        bootsCOPY(&result[j], &sum[j], bk);
    }

    delete_gate_bootstrapping_ciphertext_array(nb_bits, tmp_array);
    delete_gate_bootstrapping_ciphertext_array(nb_bits, sum);
}

void op_select(char* instruction, TFheGateBootstrappingCloudKeySet* bk, const TFheGateBootstrappingParameterSet* params) {
  char* token;
  token = strtok(instruction, " ");
  int wordSize = atoi(token);
  token = strtok(NULL, " ");
  int operation = atoi(token);

  LweSample* ciphertext1 = new_gate_bootstrapping_ciphertext_array(wordSize, params);
  LweSample* ciphertext2 = new_gate_bootstrapping_ciphertext_array(wordSize, params);
  LweSample* ciphertext3 = new_gate_bootstrapping_ciphertext_array(wordSize, params);

  LweSample* result = new_gate_bootstrapping_ciphertext_array(wordSize, params);

  FILE* ctxt_one_data;
  FILE* ctxt_two_data;
  FILE* ctxt_three_data;

  if (operation < 9) { // 2 input ciphertexts
      token = strtok(NULL, " ");
      ctxt_one_data = fopen(token, "rb");
      token = strtok(NULL, " ");
      ctxt_two_data = fopen(token, "rb");

      for (int i=0; i<wordSize; i++) {
          import_gate_bootstrapping_ciphertext_fromFile(ctxt_one_data, &ciphertext1[i], params);
          import_gate_bootstrapping_ciphertext_fromFile(ctxt_two_data, &ciphertext2[i], params);
      }


      fclose(ctxt_one_data);
      fclose(ctxt_two_data);

      if (operation == 0) { // AND
        e_and(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 1) { // NAND
        e_nand(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 2) { // OR
        e_or(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 3) { // NOR
        e_nor(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 4) { // XOR
        e_xor(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 5) { // XNOR
        e_xnor(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 6) { // subtract
        subtracter(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 7) { // add
        adder(result, ciphertext1, ciphertext2, wordSize, bk);
      }
      else if (operation == 8) { // multiply
        multiplier(result, ciphertext1, ciphertext2, wordSize, bk);
      }

  }

  else if (operation < 12) { // 1 input ciphertext
      token = strtok(NULL, " ");
      ctxt_one_data = fopen(token, "rb");

      for (int i=0; i<wordSize; i++) {
        import_gate_bootstrapping_ciphertext_fromFile(ctxt_one_data, &ciphertext1[i], params);
      }

      fclose(ctxt_one_data);

      if (operation == 9) { // NOT
        e_not(result, ciphertext1, wordSize, bk);
      }
      else if (operation == 10) { // shift left
        token = strtok(NULL, " ");
        int shift_amount = atoi(token);
        e_shl(result, ciphertext1, shift_amount, wordSize, bk);
      }
      else if (operation == 11) { // shift right
        token = strtok(NULL, " ");
        int shift_amount = atoi(token);
        e_shr(result, ciphertext1, shift_amount, wordSize, bk);
      }
  }

  else if (operation == 12) { // MUX
      token = strtok(NULL, " ");
      ctxt_one_data = fopen(token, "rb");
      token = strtok(NULL, " ");
      ctxt_two_data = fopen(token, "rb");
      token = strtok(NULL, " ");
      ctxt_three_data = fopen(token, "rb");

      for (int i=0; i<wordSize; i++) {
          import_gate_bootstrapping_ciphertext_fromFile(ctxt_one_data, &ciphertext1[i], params);
          import_gate_bootstrapping_ciphertext_fromFile(ctxt_two_data, &ciphertext2[i], params);
          import_gate_bootstrapping_ciphertext_fromFile(ctxt_three_data, &ciphertext3[i], params);
      }

      fclose(ctxt_one_data);
      fclose(ctxt_two_data);
      fclose(ctxt_three_data);

      e_mux(result, ciphertext1, ciphertext2, ciphertext3, wordSize, bk);
  }

  else if (operation == 13) { // comp
    token = strtok(NULL, " ");
    ctxt_one_data = fopen(token, "rb");
    token = strtok(NULL, " ");
    ctxt_two_data = fopen(token, "rb");
    token = strtok(NULL, " ");
    int select = atoi(token);

    for (int i=0; i<wordSize; i++) {
        import_gate_bootstrapping_ciphertext_fromFile(ctxt_one_data, &ciphertext1[i], params);
        import_gate_bootstrapping_ciphertext_fromFile(ctxt_two_data, &ciphertext2[i], params);
    }

    fclose(ctxt_one_data);
    fclose(ctxt_two_data);

    comparator(result, ciphertext1, ciphertext2, wordSize, select, bk);
  }

  else if (operation == 14) { // econst
    token = strtok(NULL, " ");
    int64_t ptxt_val = atoi(token);
    for (int i=0; i<wordSize; i++) {
        bootsCONSTANT(&result[i], (ptxt_val>>i)&1, bk);
    }
  }

  char* fileName = (char*) malloc(50);
  fileName = gen_filename();
  FILE* answer_data = fopen(fileName,"wb");
  for (int i=0; i<wordSize; i++)
      export_gate_bootstrapping_ciphertext_toFile(answer_data, &result[i], params);
  fclose(answer_data);

  // export ciphertext filename to ctxtmem.txt
  FILE* ctxt_mem = fopen("ctxtMem.txt", "a");
  fprintf(ctxt_mem, "%s", fileName);
  fprintf(ctxt_mem, "\n");
  fclose(ctxt_mem);

  free(fileName);
  delete_gate_bootstrapping_ciphertext_array(wordSize, result);
  delete_gate_bootstrapping_ciphertext_array(wordSize, ciphertext3);
  delete_gate_bootstrapping_ciphertext_array(wordSize, ciphertext2);
  delete_gate_bootstrapping_ciphertext_array(wordSize, ciphertext1);
}

int listen_for_inst(int sockfd, TFheGateBootstrappingCloudKeySet* bk, const TFheGateBootstrappingParameterSet* params) {
    char buf[MAX];
    int n;
    for (;;) {
        bzero(buf, MAX);

        read(sockfd, buf, sizeof(buf));
        printf("Received: %s\n", buf);
        if (strncmp("exit", buf, 4) == 0) {
            printf("Server Exit...\n");
            bzero(buf, MAX);
            buf[0] = 'O';
            buf[1] = 'K';
            write(sockfd, buf, sizeof(buf));
            return 0;
        }
        else if (buf[0] == 0) {
          printf("Erroneous message, returning...\n");
          return -1;
        }
        op_select(buf, bk, params);
        bzero(buf, MAX);
        buf[0] = 'O';
        buf[1] = 'K';
        printf("Sending OK...\n");
        int error_check = write(sockfd, buf, sizeof(buf));
        if (error_check < 0) {
          return -1;
        }
    }
}

int main(int argc, char** argv) {

    //reads the evaluation key from file
    FILE* cloud_key = fopen("clouds.key","rb");
    TFheGateBootstrappingCloudKeySet* bk = new_tfheGateBootstrappingCloudKeySet_fromFile(cloud_key);
    fclose(cloud_key);

    //if necessary, the params are inside the key
    const TFheGateBootstrappingParameterSet* params = bk->params;

    int sockfd, connfd, len;
    int error_check = -1;
    struct sockaddr_in servaddr, cli;
    while (error_check < 0) {
      // socket create and verification
      sockfd = socket(AF_INET, SOCK_STREAM, 0);
      if (sockfd == -1) {
          printf("socket creation failed...\n");
          exit(0);
      }
      else
          printf("Socket successfully created..\n");
      bzero(&servaddr, sizeof(servaddr));

      // assign IP, PORT
      servaddr.sin_family = AF_INET;
      servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
      servaddr.sin_port = htons(PORT);

      // Binding newly created socket to given IP and verification
      if ((bind(sockfd, (SA*)&servaddr, sizeof(servaddr))) != 0) {
          printf("socket bind failed...\n");
          exit(0);
      }
      else
          printf("Socket successfully binded..\n");

      // Now server is ready to listen and verification
      if ((listen(sockfd, 5)) != 0) {
          printf("Listen failed...\n");
          exit(0);
      }
      else
          printf("Server listening..\n");
      len = sizeof(cli);

      // Accept the data packet from client and verification
      connfd = accept(sockfd, (SA*)&cli, &len);
      if (connfd < 0) {
          printf("Server accept failed...\n");
          exit(0);
      }
      else
          printf("Server accepted the client...\n");

      // Function for chatting between client and server
      error_check = listen_for_inst(connfd, bk, params);

      // After chatting close the socket
      close(sockfd);
    }
    //clean up all pointers
    delete_gate_bootstrapping_cloud_keyset(bk);

}
