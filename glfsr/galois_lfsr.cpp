#include <iostream>
#include <bitset>
#include <stdint.h>
#include "galois_lfsr.h"

void lfsr_init(LFSR_T *plfsr) {
    //plfsr->taps = 0x00000005;  // a2 = 1, a0 = 1
    //plfsr->ymask = 0x00000010; // bit 4 is the highest significant state bit (HSSB)
    plfsr->taps  = 0x0000001d; // a4 = 1, a3 = 1, a2 = 1, a0 = 1
    plfsr->ymask = 0x0000080;  // bit 7 is the highest significant state bit (HSSB), and the bit that becomes the output
    plfsr->state = 1;
    plfsr->out   = 0;
}

/* Galois implementation of LFSR */
bool lfsr_step(LFSR_T *plfsr) {
    bool     out = (plfsr->state & plfsr->ymask) != 0;  // Only test the HSSB, that becomes our output

    plfsr->state <<= 1;   // Shift our state left by one bit (LSB becomes 0)
    plfsr->out   <<= 1;
    plfsr->out |= out;

    if (out) {
        plfsr->state ^= plfsr->taps;
        /* flip bits connected to the taps if the output (MSB) is 1
           Note that the state bits beyone the HSSB are ignored */
    }

    //#ifdef DEBUG
        //std::cout << "out/state :  " << std::bitset<8>(plfsr->out) << "  " << std::bitset<8>(plfsr->state) << std::endl; 
        //std::cout << std::endl << "state:       " << std::bitset<8>(plfsr->state) << std::endl; 
        //std::cout              << "ymask:       " << std::bitset<8>(plfsr->ymask) << std::endl;
        //std::cout              << "taps :       " << std::bitset<8>(plfsr->taps)  << std::endl;
        //std::cout              << "out:         " << out                          << std::endl;
        //std::cout              << "out_buffer:  " << std::bitset<8>(plfsr->out)   << std::endl;
    //#endif

    return out;
}
