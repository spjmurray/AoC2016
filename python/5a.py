#!/usr/bin/python

from hashlib import md5
from itertools import count

INPUT = 'cxdnnyjw'

def main():
    password = []
    for index in count(0):
        hasher = md5()
        hasher.update(INPUT)
        hasher.update(str(index))
        digest = hasher.hexdigest()
        if not digest.startswith('00000'):
            continue
        password.append(digest[5])
        if len(password) == 8:
            break
    print ''.join(password)


if __name__ == '__main__':
    main()

# vi: ts=4 et:
