#!/usr/bin/python

from collections import Counter
from itertools import islice, chain
import re


def aba(inp):
    # Get consecutive runs of 3 characters
    cons = [inp[x:x+3] for x in range(len(inp)-2)]
    # Return palindromes with 2 unique characters
    return [x for x in cons if x == x[::-1] and len(Counter(x)) == 2]


def bab(inp):
    # 'Invert' and aba into a bab
    return inp[1] + inp[0] + inp[1]


def valid(address):
    # Split an address into addresses and hypernets
    addresses = address[0::2]
    hypernets = address[1::2]
    # This is valid if any addresses have an aba and any corresponding bab exists
    # in any hypernet
    babs = frozenset(bab(x) for x in chain(*[aba(x) for x in addresses]))
    abas = frozenset(chain(*[aba(x) for x in hypernets]))
    return babs & abas


def main():
    # Read in the input splitting on non-characters e.g. '[' and ']'
    data = [re.findall(r'\w+', x) for x in open('7.in')]
    data = [x for x in data if valid(x)]
    print len(data)
        

if __name__ == '__main__':
    main()

# vi: ts=4 et:
