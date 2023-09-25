#include "filenames.h"

int exists(const char *fname)
{
    FILE *file;
    if ((file = fopen(fname, "r")))
    {
        fclose(file);
        return 1;
    }
    return 0;
}

char* gen_filename()
{
  int isTaken = 1;
  char* fileName = (char*) malloc(50);
  while (isTaken != 0) {
      strcpy(fileName, "");
      strcpy(fileName, "encrypted_data/ctxt");
      int num = rand() % 10000;
      char strNum[sizeof(num)];
      sprintf(strNum, "%d", num);
      strcat(fileName, strNum);
      strcat(fileName, ".data");
      isTaken = exists(fileName);
  }
  return fileName;
}

void seed_randomness()
{
    srand(time(0));
}