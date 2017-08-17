#!/usr/bin/python

import collections

def main():
    result = 0
    for line in open('4.in'):
        # Extract the room and extra data
        room, extra = line.rsplit('-', 1)
        # Count the occurrences of letters ignoring hyphens
        counts = collections.Counter(room.replace('-', ''))
        # Sort based on highest requency then lexically
        ordered = sorted(counts.items(), key=lambda x: (-x[1], x[0]))
        # The checksum is the first 5 characters from our ordered list
        computed = ''.join(x for x, y in ordered[:5])
        # Extract the sector and checksum
        sector, checksum = extra[:-2].split('[')
        # Ignore faulty checksums
        if checksum != computed:
            continue
        # Increment the sector counter
        result += int(sector)
    print result

if __name__ == '__main__':
    main()

# vi: ts=4 et:
