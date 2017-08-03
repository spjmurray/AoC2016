#!/usr/bin/python

import collections

INPUT = 1358

def valid(x, y):
    if x < 0 or y < 0:
        return False
    i = x*x + 3*x + 2*x*y + y + y*y + INPUT
    return ('{:b}'.format(i).count('1') & 1) == 0

class State(object):
    def __init__(self, x, y, distance):
        self.x = x
        self.y = y
        self.distance = distance

    def node(self):
        return (self.x, self.y)

    def move(self, x, y):
        return State(self.x + x, self.y + y, self.distance + 1)

queue = collections.deque()
queue.append(State(1, 1, 0))

seen = set()

while queue:
    u = queue.popleft()

    if u.distance > 50:
        break

    if u.node() in seen:
        continue
    seen.add(u.node())

    if valid(u.x-1, u.y):
        queue.append(u.move(-1, 0))
    if valid(u.x+1, u.y):
        queue.append(u.move(1, 0))
    if valid(u.x, u.y-1):
        queue.append(u.move(0, -1))
    if valid(u.x, u.y+1):
        queue.append(u.move(0, 1))

print len(seen)

# vi: ts=4 et:
