#!/usr/bin/python

from collections import Counter


def rotate_right(iterable, magnitude):
    magnitude %= len(iterable)
    return iterable[-magnitude:] + iterable[:-magnitude]


def transpose(iterable):
    return [''.join(x) for x in zip(*iterable)]


def main():
    # Screen is 50 x 6 characters
    screen = [' ' * 50] * 6
    # Load up the data lines tokenizing
    data = [x.split() for x in open('8.in')]
    for fields in data:
        # If it's a rectangle...
        if fields[0] == 'rect':
            # Calculate the dimensions
            x, y = [int(x) for x in fields[1].split('x', 1)]
            # Fill the first x characters of the first y rows
            for ty in range(0, y):
                screen[ty] = '#' * x + screen[ty][x:]
        # .. Otherwise it's a rotation
        else:
            # Extract the direction of rotation 'column' or 'row', the index and magnitude
            direction = fields[1]
            index = int(fields[2].split('=')[1])
            magnitude = int(fields[4])
            # If we are rotating a column transpose
            if direction == 'column':
                screen = transpose(screen)
            # Rotate right the specified magnitude
            screen[index] = rotate_right(screen[index], magnitude)
            # If we are rotating a column revert the transpose
            if direction == 'column':
                screen = transpose(screen)
        
    print Counter(''.join(screen))['#']


if __name__ == '__main__':
    main()

# vi: ts=4 et:
