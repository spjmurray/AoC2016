#!/usr/bin/python

import collections

def main():
    acc = []
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
        # Accumulate room and sector
        acc.append((room, int(sector)))
    for room, sector in acc:
        # Decipher the room, replacing hyphens with spaces
        def caesar(char, num):
            offset = ord('a')
            return chr((ord(char) - offset + num) % 26 + offset)
        plain = ''.join(caesar(x, sector) for x in room.replace('-', ' '))
        # Is this the north pole room?
        if 'north' in plain:
            print sector
            break

if __name__ == '__main__':
    main()

# vi: ts=4 et:
