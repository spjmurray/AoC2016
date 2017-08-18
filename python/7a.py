#!/usr/bin/python

from collections import Counter
from itertools import islice
import re


def abba(inp):
    # Get consecutive runs of 4 characters
    cons = [inp[x:x+4] for x in range(len(inp)-3)]
    # Return only palindromes with 2 unique characters
    return [x for x in cons if x == x[::-1] and len(Counter(x)) == 2]


def valid(address):
    # Split an address into addresses and hypernets
    addresses = address[0::2]
    hypernets = address[1::2]
    # This is valid if any addresses have an abba and no hypernets have an abba
    return any(abba(x) for x in addresses) and not any(abba(x) for x in hypernets)


def main():
    # Read in the input splitting on non-characters e.g. '[' and ']'
    data = [re.findall(r'\w+', x) for x in open('7.in')]
    data = [x for x in data if valid(x)]
    print len(data)
        

if __name__ == '__main__':
    main()

# vi: ts=4 et:
