#!/usr/bin/python
"""Advent of Code - Day 13"""

#pylint: disable=invalid-name

import collections

INPUT = 1358

class State(object):
    """Holds the state of our progress through the maze"""

    def __init__(self, x, y, distance):
        self.x = x
        self.y = y
        self.distance = distance

    @property
    def node(self):
        """Unique state identification"""
        return (self.x, self.y)

    @property
    def done(self):
        """Check if the state is in the required end state"""
        return self.x == 31 and self.y == 39

    @property
    def valid(self):
        """Is the current position valid"""
        if self.x < 0 or self.y < 0:
            return False
        i = self.x*self.x + 3*self.x + 2*self.x*self.y + self.y + self.y*self.y + INPUT
        return '{:b}'.format(i).count('1') & 1 == 0

    def moves(self):
        """Generator to return valid moves"""
        for i in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            m = State(self.x + i[0], self.y + i[1], self.distance + 1)
            if m.valid:
                yield m

def main():
    """A* Breadth first search"""

    # O(1) insert and deletion
    queue = collections.deque()
    queue.append(State(1, 1, 0))

    # O(log N) search
    ready = set()
    seen = set()

    while queue:
        u = queue.popleft()
        if u.done:
            break
        if u.node in seen:
            continue
        seen.add(u.node)
        for m in u.moves():
            if m.node not in seen and m.node not in ready:
                queue.append(m)
                ready.add(m)

    print u.distance

if __name__ == '__main__':
    main()

# vi: ts=4 et:
