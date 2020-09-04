#ifndef GALOIS_LFSR
#define GALOIS_LFSR

#include <stdint.h>

typedef struct {
    uint64_t state;
    uint64_t taps;
    uint64_t ymask;
    uint64_t out;    // A rolling history of all the output bits
} LFSR_T;

void lfsr_init(LFSR_T *plfsr);

/* Galois implementation of LFSR */
bool lfsr_step(LFSR_T *plfsr);

#endif