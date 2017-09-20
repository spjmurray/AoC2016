#!/usr/bin/python

import collections

def main():
    # Our VM has an instruction pointer and 4 registers a-d
    ip = 0
    registers = collections.defaultdict(int)
    registers['c'] = 1

    # Load in the assembler and tokenize
    instructions = [x.split() for x in open('12.in')]

    # Return immediate value or a register reference
    def load(ref):
        try:
            return int(ref)
        except ValueError:
            return registers[ref]

    # Execute until we access an invalid instruction
    try:
        while True:
            # Get the instruction at the IP
            instruction = instructions[ip]
            # Unpack the opcode and parameters
            opcode, params = instruction[0], instruction[1:]
            # By default all instructions increment the IP by one
            ip_next = 1
            # Copy from register or immediate to a register
            if opcode == 'cpy':
                registers[params[1]] = load(params[0])
            # Increment a register
            elif opcode == 'inc':
                registers[params[0]] += 1
            # Decrement a register
            elif opcode == 'dec':
                registers[params[0]] -= 1
            # Jump an immediate distance if a register or immediate is non zero
            elif opcode == 'jnz':
                if load(params[0]):
                    ip_next = int(params[1])
            # Increment the IP
            ip += ip_next
    except IndexError:
        pass

    print registers

if __name__ == '__main__':
    main()

# vi: ts=4 et:
