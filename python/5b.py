#!/usr/bin/python

from hashlib import md5
from itertools import count

INPUT = 'cxdnnyjw'

def main():
    password = [None] * 8
    for index in count(0):
        hasher = md5()
        hasher.update(INPUT)
        hasher.update(str(index))
        digest = hasher.hexdigest()
        if not digest.startswith('00000'):
            continue
        if not digest[5] in [str(x) for x in range(0, 8)]:
            continue
        idx = int(digest[5])
        if password[idx]:
            continue
        password[idx] = digest[6]
        if all(password):
            break
    print ''.join(password)


if __name__ == '__main__':
    main()

# vi: ts=4 et:
