#ifndef FILENAMES_H
#define FILENAMES_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int exists(const char *fname);
char* gen_filename();
void seed_randomness();
#endif
