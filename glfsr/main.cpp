#include <iostream>
#include "galois_lfsr.h"

int main() {
    LFSR_T lfsr;

    lfsr_init(&lfsr);

    for(int i = 1; i <= 80; i++) {
        bool out = lfsr_step(&lfsr);
        //std::cout << "output:  " << int(out) << std::endl;
        //std::cout << out;
        //if (i%8 == 0) std::cout << std::endl << "--------" << std::endl;  // Wrap the line every byte
    }
    //std::cout << std::endl;

    return 0;
}