#!/usr/bin/python

from collections import Counter

def main():
    # Read the input and explode the lines discarding the newline
    data = [list(x)[:-1] for x in open('6.in')]
    # Transpose
    data = zip(*data)
    # Count the characters in each tuple
    data = [Counter(x) for x in data]
    # Sort based on frequency
    data = [sorted(x, key=lambda y: x[y], reverse=True) for x in data]
    # Answer is all the most popular characters
    print ''.join(x[0] for x in data) 
    

if __name__ == '__main__':
    main()

# vi: ts=4 et:
