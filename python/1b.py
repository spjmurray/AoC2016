#!/usr/bin/python

import itertools
import sys

INPUT = 'R4, R5, L5, L5, L3, R2, R1, R1, L5, R5, R2, L1, L3, L4, R3, L1, L1, R2, R3, R3, R1, L3, L5, R3, R1, L1, R1, R2, L1, L4, L5, R4, R2, L192, R5, L2, R53, R1, L5, R73, R5, L5, R186, L3, L2, R1, R3, L3, L3, R1, L4, L2, R3, L5, R4, R3, R1, L1, R5, R2, R1, R1, R1, R3, R2, L1, R5, R1, L5, R2, L2, L4, R3, L1, R4, L5, R4, R3, L5, L3, R4, R2, L5, L5, R2, R3, R5, R4, R2, R1, L1, L5, L2, L3, L4, L5, L4, L5, L1, R3, R4, R5, R3, L5, L4, L3, L1, L4, R2, R5, R5, R4, L2, L4, R3, R1, L2, R5, L5, R1, R1, L1, L5, L5, L2, L1, R5, R2, L4, L1, R4, R3, L3, R1, R5, L1, L4, R2, L3, R5, R3, R1, L3'


class Vector(object):
    def __init__(self, x, y):
        super(Vector, self).__setattr__('x', x)
        super(Vector, self).__setattr__('y', y)

    def __add__(self, vector):
        return Vector(self.x + vector.x, self.y + vector.y)

    def __mul__(self, value):
        return Vector(self.x * value, self.y * value)

    def __setattr__(self, k, v):
        raise RuntimeError('class Vector is immutable')

    def __hash__(self):
        return hash((self.x, self.y))

    def __eq__(self, vector):
        return self.x == vector.x and self.y == vector.y

    def manhattan(self):
        return abs(self.x) + abs(self.y)


def main():
    # Where we are in the city
    position = Vector(0, 0)
    # Start pointing north, python doesn't support previous iteration of cycles
    # so we maintain an index into the current direction we are facing
    directions = [Vector(0, 1), Vector(1, 0), Vector(0, -1), Vector(-1, 0)]
    index = 0
    # Process the input into a list of tuples of index increment and magnitude
    moves = [(1 if x[0] == 'R' else -1, int(x[1:])) for x in INPUT.split(', ')]
    # Record where we have visited
    visited = set([position])
    for direction, magnitude in moves:
        # Modulo 4 to keep the index in bounds
        index = (index + direction) % 4
        # Move in the desired direction the correct number of times
        for _ in range(0, magnitude):
            position += directions[index]
            if position in visited:
                # Answer is the manhattan distance from the start point
                print position.manhattan()
                sys.exit()
            visited.add(position)


if __name__ == '__main__':
    main()

# vi: ts=4 et:
