#!/usr/bin/python

def main():
    # Process input into a list of lists for side lengths, ordered
    data = [sorted((int(y) for y in x.split()), reverse=True) for x in open('3.in')]

    # Select triangles whose border less the largest side is larger than the largest side
    valid = [x for x in data if sum(x) - x[0] > x[0]]

    # Answer is the number of valid triangles
    print len(valid)

if __name__ == '__main__':
    main()

# vi: ts=4 et:
