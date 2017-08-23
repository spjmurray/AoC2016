#!/usr/bin/python

def decompress(data):
    """
    Iterate through an iterable type e.g. string or character
    array looking for RLE control sequences and expanding the
    next N characters M times.  Return the length.
    """
    length = 0
    iterator = iter(data)
    for char in iterator:
        # Control sequence
        if char == '(':
            # Collect the control fields
            control = ""
            while True:
                peek = iterator.next()
                if peek == ')':
                    break
                control += peek
            take, times = [int(x) for x in control.split('x')]
            # Extract 'take' characters
            [iterator.next() for x in range(0, take)]
            # Accumulate 'take' characters 'times' times
            length += take * times
        else:
            length += 1
    return length


def main():
    # Load the input
    data = open('9.in').read().strip()
    # Answer is the length of the output
    print decompress(data)


if __name__ == '__main__':
    main()

# vi: ts=4 et:
