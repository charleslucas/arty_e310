#include <stdint.h>

typedef struct {
    uint64_t state;
    uint64_t taps;
    uint64_t ymask;
} LFSR_T;

void lfsr_init(LFSR_T *plfsr) {
    plfsr->state = 1;
    //plfsr->taps = 0x00000005;  // a0 = 1, a2 = 1
    //plfsr->ymask = 0x00000010; // bit 4 is the highest significant state bit (HSSB)
    plfsr->taps = 0x0000001c; // a4 = 1, a3 = 1, a2 = 1
    plfsr->ymask = 0x0000080; // bit 7 is the highest significant state bit (HSSB)
}

/* Galois implementation of LFSR */
bool lfsr_step(LFSR_T *plfsr) {
    bool out = (plfsr->state & plfsr->ymask) != 0;  // Only test the HSSB, that becomes our output
    plfsr->state <<= 1;   // Shift our state left by one bit

    if (out) {
        plfsr->state ^= plfsr->taps;
        /* flip bits connected to the taps if the output (MSB) is 1
           Note that the state bits beyone the HSSB are ignored */
    }

    return out;
}
