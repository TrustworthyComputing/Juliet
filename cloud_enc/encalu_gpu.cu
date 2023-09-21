// cuFHE includes
#include "cufhe/include/cufhe_gpu.cuh"
#include "cufhe/include/bootstrap_gpu.cuh"
#include "cufhe/include/cufhe.h"
#include "cufhe/include/ntt_gpu/ntt.cuh"

#include <cstdio>
#include <netdb.h>
#include <netinet/in.h>
#include <unistd.h>
#include <cstdlib>
#include <cstring>
#include <sys/socket.h>
#include <sys/types.h>
#include <iostream>
#include <fstream>
#include <string>
#include <sys/stat.h>

#define MAX 100
#define PORT 8080
#define SA struct sockaddr
#define NUM_SMS 16

using namespace cufhe;
using namespace std;

int st_ctr = 0;

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

// Constant Encryptions
void NoiselessTrivial(Ctxt& result, Torus mu, int32_t n=500){
    const int32_t degree = n;

    for (int32_t i = 0; i < degree; ++i) result.lwe_sample_->a()[i] = 0;
    result.lwe_sample_->b() = mu;
}

void Constant(Ctxt& result, int32_t value) {
    static const Torus MU = ModSwitchToTorus(1, 8);
    NoiselessTrivial(result, value ? MU : -MU);
}

// GPU <-> CPU data transfers
void CtxtCopyH2D(const Ctxt& c, Stream st) {
  cudaMemcpyAsync(c.lwe_sample_device_->data(),
                  c.lwe_sample_->data(),
                  c.lwe_sample_->SizeData(),
                  cudaMemcpyHostToDevice,
                  st.st());
}
void CtxtCopyD2H(const Ctxt& c, Stream st) {
  cudaMemcpyAsync(c.lwe_sample_->data(),
                  c.lwe_sample_device_->data(),
                  c.lwe_sample_->SizeData(),
                  cudaMemcpyDeviceToHost,
                  st.st());
}

// Logic Functions

// 0
void e_and(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        And(result[i], a[i], b[i], st_list[i%NUM_SMS]);
    }
}
// 1
void e_nand(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Nand(result[i], a[i], b[i], st_list[i%NUM_SMS]);
    }
}
// 2
void e_or(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Or(result[i], a[i], b[i], st_list[i%NUM_SMS]);
    }
}
// 3
void e_nor(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Nor(result[i], a[i], b[i], st_list[i%NUM_SMS]);
    }
}
// 4
void e_xor(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Xor(result[i], a[i], b[i], st_list[i%NUM_SMS]);
    }
}
// 5
void e_xnor(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Xnor(result[i], a[i], b[i], st_list[i%NUM_SMS]);
    }
}
// 9
void e_not(Ctxt* result, const Ctxt* a, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Not(result[i], a[i], st_list[i%NUM_SMS]);
    }
}
// 10
void e_shl(Ctxt* result, Ctxt* temp, const Ctxt* a, const int shift_amt, const int nb_bits, Stream* st_list) {
  // Ctxt* temp = new Ctxt[nb_bits];

  for(int i = 0; i < nb_bits; i++) {
    Copy(result[i], a[i], st_list[i%NUM_SMS]);
  }

  for(int i = 0; i < shift_amt; i++) {
    for(int j = 1; j < nb_bits; j++) {
      Copy(temp[j], result[j-1], st_list[i%NUM_SMS]);
    }

    for(int k = 1; k < nb_bits; k++) {
      Copy(result[k], temp[k], st_list[i%NUM_SMS]);
    }

    Constant(result[0], 0); // set lowest bit to 0

  }
}

// 11
void e_shr(Ctxt* result, Ctxt* temp, const Ctxt* a, const int shift_amt, const int nb_bits, Stream* st_list) {

  // Ctxt* temp = new Ctxt[nb_bits];

  for(int i = 0; i < nb_bits; i++) {
    Copy(result[i], a[i], st_list[i%NUM_SMS]);
  }

  for(int i = 0; i < shift_amt; i++) {
    for(int j = 0; j < nb_bits - 1; j++) {
      Copy(temp[j], result[j+1], st_list[i%NUM_SMS]);
    }


    for(int k = 0; k < nb_bits; k++) {
      Copy(result[k], temp[k], st_list[i%NUM_SMS]);
    }

    Constant(result[nb_bits - 1], 0); // set highest bit to 0

  }
}

// 12

__global__
void AddToOp(Torus* out, Torus* in0, uint32_t n) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < (n+1)) {
    out[i] += in0[i];
  }
}

__global__
void SubToOp(Torus* out, Torus* in0, uint32_t n) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < (n+1)) {
    out[i] -= in0[i];
  }
}

void Mux(Ctxt& result, const Ctxt& a, const Ctxt& b, const Ctxt& c, Stream st) {

  CtxtCopyH2D(a, st);
  CtxtCopyH2D(b, st);
  CtxtCopyH2D(c, st);

  static const Torus mu_boot = ModSwitchToTorus(1, 8);
  static const Torus mu_mux = ModSwitchToTorus(1, 8);
  static const Torus mu_and = ModSwitchToTorus(-1, 8);

  Ctxt* temp_result = new Ctxt;
  Ctxt* temp_result1 = new Ctxt(false, 1024);
  Ctxt* u1 = new Ctxt(false, 1024);
  Ctxt* u2 = new Ctxt(false, 1024);

  NoiselessTrivial(*temp_result, mu_and);
  AddToOp<<<1,512,0,st.st()>>>(temp_result->lwe_sample_device_->data(), a.lwe_sample_device_->data(), a.lwe_sample_device_->n());
  AddToOp<<<1,512,0,st.st()>>>(temp_result->lwe_sample_device_->data(), b.lwe_sample_device_->data(), b.lwe_sample_device_->n());
  Bootstrap_woKS(u1->lwe_sample_device_, temp_result->lwe_sample_device_, mu_boot, st.st());

  NoiselessTrivial(*temp_result, mu_and);
  SubToOp<<<1,512,0,st.st()>>>(temp_result->lwe_sample_device_->data(), a.lwe_sample_device_->data(), a.lwe_sample_device_->n());
  AddToOp<<<1,512,0,st.st()>>>(temp_result->lwe_sample_device_->data(), c.lwe_sample_device_->data(), c.lwe_sample_device_->n());
  Bootstrap_woKS(u2->lwe_sample_device_, temp_result->lwe_sample_device_, mu_boot, st.st());

  NoiselessTrivial(*temp_result1, mu_mux);
  AddToOp<<<1,512,0,st.st()>>>(temp_result1->lwe_sample_device_->data(), u1->lwe_sample_device_->data(), u1->lwe_sample_device_->n());
  AddToOp<<<1,512,0,st.st()>>>(temp_result1->lwe_sample_device_->data(), u2->lwe_sample_device_->data(), u2->lwe_sample_device_->n());
  KeySwitchHost(result.lwe_sample_device_, temp_result1->lwe_sample_device_, st.st());
  CtxtCopyD2H(result, st);
}

void e_mux(Ctxt* result, const Ctxt* sel, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {
    for (int i=0; i<nb_bits; i++) {
        Mux(result[i], sel[0], a[i], b[i], st_list[i%NUM_SMS]);
    }
}

// Arithmetic Functions

// 13
void comparator(Ctxt* result, Ctxt* not_a, Ctxt* not_b, Ctxt* temp, Ctxt* greater_than, Ctxt* equal, Ctxt* less_than, const Ctxt* a, const Ctxt* b, const int nb_bits, const int select, Stream st) {

    // Ctxt* not_a = new Ctxt;
    // Ctxt* not_b = new Ctxt;
    // Ctxt* temp = new Ctxt[10];
    // Ctxt* greater_than = new Ctxt;
    // Ctxt* equal = new Ctxt;
    // Ctxt* less_than = new Ctxt;

    // initialize cascading inputs
    Constant(greater_than[0], 0);
    Constant(less_than[0], 0);
    Constant(equal[0], 1);

    //run 1 bit comparators
    for (int i = (nb_bits - 1); i > -1; i--) {
    //for (int i = 0; i < nb_bits; i++) {
        // invert inputs
        Not(not_a[0], a[i], st);
        Not(not_b[0], b[i], st);

        // compute greater than path
        Not(temp[0], greater_than[0], st);
        Nand(temp[1], a[i], not_b[0], st);
        Nand(temp[2], temp[1], equal[0], st);
        Not(temp[3], temp[2], st);
        Nand(greater_than[0], temp[0], temp[3], st);
        Not(temp[8], less_than[0], st);
        And(greater_than[0], temp[8], greater_than[0], st);

        // compute less than path
        Not(temp[4], less_than[0], st);
        Nand(temp[5], not_a[0], b[i], st);
        Nand(temp[6], temp[5], equal[0], st);
        Not(temp[7], temp[6], st);
        Nand(less_than[0], temp[7], temp[4], st);
        Not(temp[9], greater_than[0], st);
        And(less_than[0], temp[9], less_than[0], st);

        // compute equality path
        Nor(equal[0], greater_than[0], less_than[0], st);
    }

    // select desired output
    if (select == 0) { // ecmpeq
        Copy(result[0], equal[0], st);
    }
    else if (select == 1) { // ecmpl
        Copy(result[0], less_than[0], st);
    }
    else if (select == 2) { // ecmpg
        Copy(result[0], greater_than[0], st);
    }
    else if (select == 3) { // ecmpgeq
        Or(result[0], equal[0], greater_than[0], st);
    }
    else if (select == 4) { // ecmpleq
        Or(result[0], equal[0], less_than[0], st);
    }
    else if (select == 5) { // ecmpneq
      Copy(result[0], equal[0], st);
      Not(result[0], result[0], st);
    }

    // align to word size
    for (int i = 1; i < nb_bits; i++) {
        Constant(result[i], 0);
    }

    //delete [] not_a;
    //delete [] not_b;
    //delete [] temp;
    //delete [] greater_than;
    //delete [] equal;
    //delete [] less_than;
}

void ripple_adder(Ctxt* result, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {

    Ctxt* carry = new Ctxt[nb_bits+1];
    Ctxt* temp = new Ctxt[1];
    //initialize first carry to 0
    Constant(carry[0], 0);

    //run full adders
    for (int i = 0; i < nb_bits; i++) {
      Xor(temp[0], a[i], b[i], st[i%NUM_SMS]);
      // Compute sum
      Xor(result[i], carry[i], temp[0], st[i%NUM_SMS]);
      // Compute carry
      Mux(carry[i+1], temp[0], carry[i], a[i], st[i%NUM_SMS]);
    }

    delete [] carry;
    delete [] temp;
}

//7
void adder(Ctxt* result, Ctxt* carry_out, Ctxt** p, Ctxt** g, Ctxt* temp, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {

    // Stage 1
    // level 1: 32 parallel gates
    for (int i = 0; i < 16; i++) {
      Xor(p[0][i], a[i], b[i], st_list[i%NUM_SMS]);
      And(g[0][i], a[i], b[i], st_list[(16+i)%NUM_SMS]);
    }

    Synchronize();

    // Stage 2
    // level 2: 30 parallel gates
    // level 3: 15 parallel gates (OR gate depends on AND)
    for (int i = 0; i < 16; i++) {
      if (i == 0) {
        Copy(g[1][i], g[0][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[0][i], g[0][i-1], st_list[i%NUM_SMS]);
        Or(g[1][i], temp[i], g[0][i], st_list[i%NUM_SMS]);
        And(p[1][i], p[0][i], p[0][i-1], st_list[(16+i)%NUM_SMS]);
      }
    }

    Synchronize();

    // Stage 3
    // level 4: 27 parallel gates 
    // level 5: 14 parallel gates
    for (int i = 1; i < 16; i++) {
      if (i == 1) {
        Copy(g[2][i], g[1][i], st_list[i%NUM_SMS]);
      }
      else if (i == 2) {
        And(temp[i], g[1][i-2], p[1][i], st_list[i%NUM_SMS]);
        Or(g[2][i], temp[i], g[1][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[1][i], g[1][i-2], st_list[i%NUM_SMS]);
        Or(g[2][i], temp[i], g[1][i], st_list[i%NUM_SMS]);
        And(p[2][i], p[1][i], p[1][i-2], st_list[(16+i)%NUM_SMS]);
      }
    }

    Synchronize();

    // Stage 4
    // level 6: 21 parallel gates
    // level 7: 12 parallel gates
    for (int i = 3; i < 16; i++) {
      if (i == 3) {
        Copy(g[3][i], g[2][i], st_list[i%NUM_SMS]);
      }
      else if (i == 4) {
        And(temp[i], g[1][i-4], p[2][i], st_list[i%NUM_SMS]);
        Or(g[3][i], temp[i], g[2][i], st_list[i%NUM_SMS]);
      }
      else if (i < 7) {
        And(temp[i], g[2][i-4], p[2][i], st_list[i%NUM_SMS]);
        Or(g[3][i], temp[i], g[2][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[2][i], g[2][i-4], st_list[i%NUM_SMS]);
        Or(g[3][i], temp[i], g[2][i], st_list[i%NUM_SMS]);
        And(p[3][i], p[2][i], p[2][i-4], st_list[(16+i)%NUM_SMS]);
      }
    }

    Synchronize();

    // Stage 5
    // level 8: 9 parallel gates
    // level 9: 8 parallel gates
    for (int i = 7; i < 16; i++) {
      if (i == 7) {
        Copy(g[4][i], g[3][i], st_list[i%NUM_SMS]);
      }
      else if (i == 8) {
        And(temp[i], g[1][i-8], p[3][i], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
      }
      else if (i < 11) {
        And(temp[i], g[2][i-8], p[3][i], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
      }
      else if (i < 15) {
        And(temp[i], g[3][i-8], p[3][i], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[3][i], g[3][i-8], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
        And(p[4][i], p[3][i], p[3][i-8], st_list[(16+i)%NUM_SMS]);
      }
    }

    Synchronize();

    // Generate Sum and Carry Out
    // level 10: 15 parallel gates
    for (int i = 0; i < 16; i++) {
      if (i == 0) {
        Copy(result[i], p[0][i], st_list[i%NUM_SMS]);
      }
      else if (i == 1) {
        Xor(result[i], g[1][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
      else if (i < 4) {
        Xor(result[i], g[2][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
      else if (i < 8) {
        Xor(result[i], g[3][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
      else {
        Xor(result[i], g[4][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
    }
    Copy(carry_out[0], g[4][15], st_list[0]);

    return;
}

// 6
void subtracter(Ctxt* result, Ctxt* b, Ctxt* one, Ctxt* borrow_out, Ctxt** p, Ctxt** g, Ctxt* temp, const Ctxt* a, const Ctxt* b_in, const int nb_bits, Stream* st_list) {

    // compute 2's complement of b_in
    for (int i = 0; i < 16; i++) {
      Not(b[i], b_in[i], st_list[i%NUM_SMS]);
      if (i == 0) {
        Constant(one[i], 1);
      }
      else {
        Constant(one[i], 0);
      }
    }
    adder(b, borrow_out, p, g, temp, b, one, nb_bits, st_list);

    // stage 1
    for (int i = 0; i < 16; i++) {
      Xor(p[0][i], a[i], b[i], st_list[i%NUM_SMS]);
      And(g[0][i], a[i], b[i], st_list[i%NUM_SMS]);
    }

    Synchronize();

    // stage 2
    for (int i = 0; i < 16; i++) {
      if (i == 0) {
        Copy(g[1][i], g[0][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[0][i], g[0][i-1], st_list[i%NUM_SMS]);
        Or(g[1][i], temp[i], g[0][i], st_list[i%NUM_SMS]);
        And(p[1][i], p[0][i], p[0][i-1], st_list[i%NUM_SMS]);
      }
    }

    Synchronize();

    // stage 3
    for (int i = 1; i < 16; i++) {
      if (i == 1) {
        Copy(g[2][i], g[1][i], st_list[i%NUM_SMS]);
      }
      else if (i == 2) {
        And(temp[i], g[1][i-2], p[1][i], st_list[i%NUM_SMS]);
        Or(g[2][i], temp[i], g[1][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[1][i], g[1][i-2], st_list[i%NUM_SMS]);
        Or(g[2][i], temp[i], g[1][i], st_list[i%NUM_SMS]);
        And(p[2][i], p[1][i], p[1][i-2], st_list[i%NUM_SMS]);
      }
    }

    Synchronize();

    // stage 4
    for (int i = 3; i < 16; i++) {
      if (i == 3) {
        Copy(g[3][i], g[2][i], st_list[i%NUM_SMS]);
      }
      else if (i == 4) {
        And(temp[i], g[1][i-4], p[2][i], st_list[i%NUM_SMS]);
        Or(g[3][i], temp[i], g[2][i], st_list[i%NUM_SMS]);
      }
      else if (i < 7) {
        And(temp[i], g[2][i-4], p[2][i], st_list[i%NUM_SMS]);
        Or(g[3][i], temp[i], g[2][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[2][i], g[2][i-4], st_list[i%NUM_SMS]);
        Or(g[3][i], temp[i], g[2][i], st_list[i%NUM_SMS]);
        And(p[3][i], p[2][i], p[2][i-4], st_list[i%NUM_SMS]);
      }
    }

    Synchronize();

    // stage 5
    for (int i = 7; i < 16; i++) {
      if (i == 7) {
        Copy(g[4][i], g[3][i], st_list[i%NUM_SMS]);
      }
      else if (i == 8) {
        And(temp[i], g[1][i-8], p[3][i], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
      }
      else if (i < 11) {
        And(temp[i], g[2][i-8], p[3][i], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
      }
      else if (i < 15) {
        And(temp[i], g[3][i-8], p[3][i], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
      }
      else {
        And(temp[i], p[3][i], g[3][i-8], st_list[i%NUM_SMS]);
        Or(g[4][i], temp[i], g[3][i], st_list[i%NUM_SMS]);
        And(p[4][i], p[3][i], p[3][i-8], st_list[i%NUM_SMS]);
      }
    }

    Synchronize();

    // Generate Sum and Carry Out
    for (int i = 0; i < 16; i++) {
      if (i == 0) {
        Copy(result[i], p[0][i], st_list[i%NUM_SMS]);
      }
      else if (i == 1) {
        Xor(result[i], g[1][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
      else if (i < 4) {
        Xor(result[i], g[2][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
      else if (i < 8) {
        Xor(result[i], g[3][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
      else {
        Xor(result[i], g[4][i-1], p[0][i], st_list[i%NUM_SMS]);
      }
    }
    Copy(borrow_out[0], g[4][15], st_list[0]);

    return;
}

// 8
void multiplier(Ctxt* result, Ctxt* overflow, Ctxt** prods, Ctxt** p, Ctxt** g, Ctxt* temp, Ctxt* temp_shift, const Ctxt* a, const Ctxt* b, const int nb_bits, Stream* st_list) {

    // Ctxt* prods[nb_bits];
    // for (int i = 0; i < nb_bits; i++) {
    //   prods[i] = new Ctxt[nb_bits];
    // }

    // generate partial products
    for (int i = 0; i < nb_bits; i++) {
      e_shl(prods[i], temp_shift, a, i, nb_bits, st_list);
      for (int j = 0; j < nb_bits; j++) {
        And(prods[i][j], prods[i][j], b[i], st_list[i%NUM_SMS]);
      }
    }

    // load first partial product into result
    for (int i = 0; i < nb_bits; i++) {
      Copy(result[i], prods[0][i], st_list[i%NUM_SMS]);
    }

    // accumulate partial sums (no parallelization here since all 16 SMs are used by the adder)
    for (int i = 1; i < nb_bits; i++) {
      adder(result, overflow, p, g, temp, result, prods[i], nb_bits, st_list);
    }

    return;
}

void op_select(char* instruction, Stream* st_list, Ctxt* ciphertext1, Ctxt* ciphertext2, Ctxt* ciphertext3, Ctxt* result, Ctxt* old_status, Ctxt* new_status, Ctxt** prods, Ctxt** p, Ctxt** g, Ctxt* temp_adder, Ctxt* not_a, Ctxt* not_b, Ctxt* temp_comp, Ctxt* greater_than, Ctxt* equal, Ctxt* less_than, Ctxt* temp_shift, Ctxt* temp_inv, Ctxt* one) {
  char* token;
  token = strtok(instruction, " ");
  int wordSize = atoi(token);
  token = strtok(NULL, " ");
  int operation = atoi(token);

  // Ctxt* ciphertext1 = new Ctxt[wordSize];
  // Ctxt* ciphertext2 = new Ctxt[wordSize];
  // Ctxt* ciphertext3 = new Ctxt[wordSize];
  // Ctxt* old_status = new Ctxt[1];
  // Ctxt* new_status = new Ctxt[1];

  ifstream status_data ("encrypted_data/status.data");
  ReadCtxtFromFile(old_status[0], status_data);

  // Ctxt* result = new Ctxt[wordSize];

  if (operation < 9) { // 2 input ciphertexts
      token = strtok(NULL, " ");
      const std::string temp = string(token);
      ifstream ctxt_one_data (temp);
      token = strtok(NULL, " ");
      const std::string temp2 = string(token);
      ifstream ctxt_two_data (temp2);

      for (int i=0; i<wordSize; i++) {
          ReadCtxtFromFile(ciphertext1[i], ctxt_one_data);
          ReadCtxtFromFile(ciphertext2[i], ctxt_two_data);
      }


      ctxt_one_data.close();
      ctxt_two_data.close();

      if (operation == 0) { // AND
        e_and(result, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 1) { // NAND
        e_nand(result, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 2) { // OR
        e_or(result, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 3) { // NOR
        e_nor(result, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 4) { // XOR
        e_xor(result, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 5) { // XNOR
        e_xnor(result, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 6) { // subtract
        subtracter(result, temp_inv, one, new_status, p, g, temp_adder, ciphertext1, ciphertext2, wordSize, st_list);
        st_ctr++;
      }
      else if (operation == 7) { // add
        adder(result, new_status, p, g, temp_adder, ciphertext1, ciphertext2, wordSize, st_list);
      }
      else if (operation == 8) { // multiply
        multiplier(result, new_status, prods, p, g, temp_adder, temp_shift, ciphertext1, ciphertext2, wordSize, st_list);
        st_ctr++;
      }

  }

  else if (operation < 12) { // 1 input ciphertext
      token = strtok(NULL, " ");
      const std::string temp = string(token);
      ifstream ctxt_one_data (temp);

      for (int i=0; i<wordSize; i++) {
        ReadCtxtFromFile(ciphertext1[i], ctxt_one_data);
      }

      ctxt_one_data.close();

      if (operation == 9) { // NOT
        e_not(result, ciphertext1, wordSize, st_list);
      }
      else if (operation == 10) { // shift left
        token = strtok(NULL, " ");
        int shift_amount = atoi(token);
        e_shl(result, temp_shift, ciphertext1, shift_amount, wordSize, st_list);
      }
      else if (operation == 11) { // shift right
        token = strtok(NULL, " ");
        int shift_amount = atoi(token);
        e_shr(result, temp_shift, ciphertext1, shift_amount, wordSize, st_list);
      }
  }

  else if (operation == 12) { // MUX
      token = strtok(NULL, " ");
      const std::string temp = string(token);
      ifstream ctxt_one_data (temp);
      token = strtok(NULL, " ");
      const std::string temp2 = string(token);
      ifstream ctxt_two_data (temp2);
      token = strtok(NULL, " ");
      const std::string temp3 = string(token);
      ifstream ctxt_three_data (temp3);


      for (int i=0; i<wordSize; i++) {
          ReadCtxtFromFile(ciphertext1[i], ctxt_one_data);
          ReadCtxtFromFile(ciphertext2[i], ctxt_two_data);
          ReadCtxtFromFile(ciphertext3[i], ctxt_three_data);
      }

      ctxt_one_data.close();
      ctxt_two_data.close();
      ctxt_three_data.close();

      e_mux(result, ciphertext1, ciphertext2, ciphertext3, wordSize, st_list);
  }

  else if (operation == 13) { // comp
    token = strtok(NULL, " ");
    const std::string temp = string(token);
    ifstream ctxt_one_data (temp);
    token = strtok(NULL, " ");
    const std::string temp2 = string(token);
    ifstream ctxt_two_data (temp2);
    token = strtok(NULL, " ");
    int select = atoi(token);

    for (int i=0; i<wordSize; i++) {
        ReadCtxtFromFile(ciphertext1[i], ctxt_one_data);
        ReadCtxtFromFile(ciphertext2[i], ctxt_two_data);
    }

    ctxt_one_data.close();
    ctxt_two_data.close();

    comparator(result, not_a, not_b, temp_comp, greater_than, equal, less_than, ciphertext1, ciphertext2, wordSize, select, st_list[st_ctr%NUM_SMS]);
  }

  else if (operation == 14) { // econst
    token = strtok(NULL, " ");
    int64_t ptxt_val = atoi(token);
    for (int i=0; i<wordSize; i++) {
        Constant(result[i], (ptxt_val>>i)&1);
    }
  }
  Synchronize();
  CuCheckError();
  string fileName = gen_filename();
  for (int i=0; i<wordSize; i++)
      WriteCtxtToFile(result[i], fileName);

  if ((operation == 7) || (operation == 8)) {
    Or(new_status[0], new_status[0], old_status[0], st_list[0]);
    std::ofstream ofs;
    ofs.open("encrypted_data/status.data", std::ofstream::out | std::ofstream::trunc);
    ofs.close();
    WriteCtxtToFile(new_status[0], "encrypted_data/status.data");
  }
  // export ciphertext filename to ctxtmem.txt
  ofstream ctxt_mem;
  ctxt_mem.open("ctxtMem.txt", ios_base::app);
  ctxt_mem << fileName;
  ctxt_mem << "\n";
  ctxt_mem.close();
}

int listen_for_inst(int sockfd, Stream* st_list, Ctxt* ciphertext1, Ctxt* ciphertext2, Ctxt* ciphertext3, Ctxt* result, Ctxt* old_status, Ctxt* new_status, Ctxt** prods, Ctxt** p, Ctxt** g, Ctxt* temp, Ctxt* not_a, Ctxt* not_b, Ctxt* temp_comp, Ctxt* greater_than, Ctxt* equal, Ctxt* less_than, Ctxt* temp_shift, Ctxt* temp_inv, Ctxt* one) {

    char buf[MAX];
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
        op_select(buf, st_list, ciphertext1, ciphertext2, ciphertext3, result, old_status, new_status, prods, p, g, temp, not_a, not_b, temp_comp, greater_than, equal, less_than, temp_shift, temp_inv, one);
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

    cudaSetDevice(0);

    // read evaluation key from file
    PubKey bk;
    ReadPubKeyFromFile(bk, "eval.key");
    Initialize(bk);

    // Allocate ctxt objects up front
    Ctxt* ciphertext1 = new Ctxt[16];
    Ctxt* ciphertext2 = new Ctxt[16];
    Ctxt* ciphertext3 = new Ctxt[16];
    Ctxt* result = new Ctxt[16];
    Ctxt* old_status = new Ctxt[1];
    Ctxt* new_status = new Ctxt[1];
    Ctxt* prods[16];
    for (int i = 0; i < 16; i++) {
      prods[i] = new Ctxt[16];
    }
    Ctxt* p[5];
    Ctxt* g[5];
    for (int i = 0; i < (5); i++) {
      p[i] = new Ctxt[16];
      g[i] = new Ctxt[16];
    }
    Ctxt* temp = new Ctxt[16];
    Ctxt* not_a = new Ctxt;
    Ctxt* not_b = new Ctxt;
    Ctxt* temp_comp = new Ctxt[10];
    Ctxt* greater_than = new Ctxt;
    Ctxt* equal = new Ctxt;
    Ctxt* less_than = new Ctxt;
    Ctxt* temp_shift = new Ctxt[16];
    Ctxt* temp_inv = new Ctxt[16];
    Ctxt* one = new Ctxt[16];


    // create streams
    Stream* st_list = new Stream[NUM_SMS];
    for (int i = 0; i < NUM_SMS; i++) {
      st_list[i].Create();
    }

    int sockfd, connfd;
    socklen_t len;
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
      error_check = listen_for_inst(connfd, st_list, ciphertext1, ciphertext2, ciphertext3, result, old_status, new_status, prods, p, g, temp, not_a, not_b, temp_comp, greater_than, equal, less_than, temp_shift, temp_inv, one);

      // After chatting close the socket
      close(sockfd);
    }
    //clean up all pointers
    CleanUp();

    delete [] ciphertext1;
    delete [] ciphertext2;
    delete [] ciphertext3;
    delete [] result;
    delete [] old_status;
    delete [] new_status;
    for (int size_i = 0; size_i < 16; size_i++) {
      delete [] prods[size_i];
    }
    for (int size_i = 0; size_i < 5; size_i++) {
      delete [] p[size_i];
      delete [] g[size_i];
    }
    delete [] temp;
    delete [] not_a;
    delete [] not_b;
    delete [] temp_comp;
    delete greater_than;
    delete equal;
    delete less_than;
    delete [] temp_shift;
    delete [] temp_inv;
    delete [] one;
}
