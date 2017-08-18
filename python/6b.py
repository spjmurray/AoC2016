#!/usr/bin/python

from collections import Counter


def main():
    # Read the input and explode the lines discarding the newline
    data = [list(x.strip()) for x in open('6.in')]
    # Transpose
    data = zip(*data)
    # Count the characters in each tuple; answer is all the least popular characters
    print ''.join(Counter(x).most_common()[-1][0] for x in data)
    

if __name__ == '__main__':
    main()

# vi: ts=4 et:
