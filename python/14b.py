#!/usr/bin/python

import collections
import hashlib
import itertools

import sys

INPUT = 'ngcjuoqr'


class Hash:
    def __init__(self, salt):
        self.salt = salt
        self.cache = {}

    def hash(self, index):
        if index in self.cache:
            return self.cache[index]
        digest = self.salt + str(index)
        for x in range(0, 2017):
            md5 = hashlib.md5()
            md5.update(digest)
            digest = md5.hexdigest()
        self.cache[index] = digest
        return digest


def main():
    hasher = Hash(INPUT)
    keys = []
    for i in itertools.count(0):
        if len(keys) == 64:
            print i
            break
        digest = hasher.hash(i)
        cons = [digest[x:x+3] for x in range(0, len(digest)-2)]
        groups = [x for x in cons if len(collections.Counter(x)) == 1]
        if len(groups) == 0:
            continue
        for j in range(0, 1000):
            if iter(groups[0]).next() * 5 in hasher.hash(i+j+1):
                keys.append(digest)
                break

if __name__ == '__main__':
    main()

# vi: ts=4 et:
