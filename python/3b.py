#!/usr/bin/python

import itertools

def main():
    # Process input into a list of lists
    data = [[int(y) for y in x.split()] for x in open('3.in')]

    # Transpose
    data = zip(*data)

    # Flatten
    data = list(itertools.chain(*data))

    # Chunk into groups of 3 sorted
    data = [sorted(data[x:x+3], reverse=True) for x in range(0, len(data), 3)]

    # Select triangles whose border less the largest side is larger than the largest side
    valid = [x for x in data if sum(x) - x[0] > x[0]]

    # Answer is the number of valid triangles
    print len(valid)

if __name__ == '__main__':
    main()

# vi: ts=4 et:
