#include <iostream>
#include "galois_lfsr.h"

int main() {
    LFSR_T lfsr;

    lfsr_init(&lfsr);

    for(int i = 0; i < 800; i++) {
        bool out = lfsr_step(&lfsr);
        std::cout << int(out);
        if ((i+1)%8 == 0) std::cout << std::endl;  // Wrap the line every byte
    }
    std::cout << std::endl;

    return 0;
}