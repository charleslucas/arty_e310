import sys

class glfsr:
    """A galois LFSR instance that will generate a SystemVerilog file for a specific LFSR width and polynomial"""

    def __init__(self, width, bpc, taps):
        self.state_width = width
        self.bits_per_clock = bpc
        self.taps = taps
        self.t = []  # t is an array of bits that indicate if that state bit has a tap input
        self.s = []  # s is an array of strings for systemverilog lfsr state assignments
        self.o = []  # o is an array of strings for systemverilog lfsr output assignments
    #end __init__

    def shift(self, bits, width):
        """Shift all the bit equations towards the MSB by one and clear bit 0 - this will lose the MSB value"""
        for x in reversed(range(width-1)):
            bits[x+1] = bits[x]

        bits[0] = ''   # Clear bit[0] for now, it will get set by tap[0]

        #for x in range(width):
        #    print(f"{x}: {bits[x]}")
        #print()

        return bits
    #end shift


    def encapsulate_term(self, term):
        """Put parenthesis around a term"""
        return('(' + term.rstrip('*') + ')')
    #end encapsulate_term


    def generate_equations(self):
        for x in range(self.state_width):
            """ Create our "0bpc" per-bit assignments to start from"""
            self.s.append("state[" + str(x) + "]")
            self.t.append(0)

        for tap in self.taps:
            """Create an array where each entry indicates if the corresponding bit has a tap input"""
            self.t[int(tap)] = int(1)
        
        print()
        for i in range(len(self.t)):
            """Create an array where each entry indicates if the corresponding bit has a tap input"""
            print(f"t{i}:  {self.t[i]}")
        print()

        for x in range(self.bits_per_clock):
            """For each bpc step, append the logic which will predict the value of each bit one clock further ahead in time"""
            """Basically, shift everything one bit left, then if a tap exists, add the term from the previous MSB"""
            tap_term = self.s[self.state_width-1].rstrip('*')

            # Create a new output MSB with the current MSB
            if len(self.o) == 0:
                self.o.append(self.s[self.state_width-1])
            else:
                self.o.append(self.o[len(self.o)-1])

            # Shift all the other values up one
            for i in reversed(range(1, len(self.o)-1)):
                self.o[i] = self.o[i-1]

            self.o[0] = tap_term

            if '^' in tap_term:
                tap_term = self.encapsulate_term(tap_term)

            self.s = self.shift(self.s, self.state_width)

            self.s[0] = (('*'*11)*(x+1)) + tap_term  # Add leading spaces

            for y in range(1, self.state_width):
                if self.t[y] == 1:  # If this bit has a tap input
                    self.s[y] = self.s[y] + ' ^ ' + tap_term.rstrip('*')
                else:
                    self.s[y] = self.s[y] + '*'*len(tap_term) + '*'*3

            for x in range(self.state_width):
                print(f"s{x}:  {self.s[x]}")
            print();

            for x in range(len(self.o)):
                print(f"o{x}:  {self.o[x]}")
            print();

    #end generate_equations

#end class glfsr


### Main
if __name__ == "__main__":
#    print(f"Arguments count: {len(sys.argv)}")
    taps=[]
    for i, arg in enumerate(sys.argv):
        if i == 0:
            """nothing"""
        elif i == 1:
            state_width = int(arg)
        elif i == 2:
            bits_per_clock = int(arg)
        else:
            taps.append(int(arg))

#        print(f"Argument {i:>6}: {arg}")
else:
    state_width = 8
    bits_per_clock = 1
    taps = [4, 3, 2, 0]

print(f"state_width == {state_width}")
print(f"bits_per_clock == {bits_per_clock}")
print(f"taps = ")
for t in taps:
    if (t >= state_width-1):
        print(f"Error - invalid tap:  {t}")
        exit()
    else:
        print(f"{t} ")

lfsr = glfsr(state_width, bits_per_clock, taps)

lfsr.generate_equations()


