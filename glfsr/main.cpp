#include <iostream>
#include <bitset>
#include "galois_lfsr.h"

int main() {
    LFSR_T lfsr;

    lfsr_init(&lfsr);

    std::cout << "out/state :  " << std::bitset<8>(0) << "  " << std::bitset<8>(0) << std::endl; 

    for(int i = 1; i <= 24000; i++) {
        bool out = lfsr_step(&lfsr);
        if (i%8 == 0) std::cout << "out/state :  " << std::bitset<8>(lfsr.out) << "  " << std::bitset<8>(lfsr.state) << std::endl; 
        //std::cout << "output:  " << int(out) << std::endl;
        //std::cout << out;
        //if (i%8 == 0) std::cout << std::endl << "--------" << std::endl;  // Wrap the line every byte
    }
    //std::cout << std::endl;

    return 0;
}