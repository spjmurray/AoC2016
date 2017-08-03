#!/usr/bin/python
"""Advent of Code - Day 11"""

#pylint: disable=invalid-name

import collections
import copy
import itertools

INPUT = {
    'thulium': [0, 0],
    'plutonium': [0, 1],
    'strontium': [0, 1],
    'promethium': [2, 2],
    'ruthenium': [2, 2],
}

GENERATOR = 0
CHIP = 1

class State(object):
    """Holds the state of our progress through the maze"""

    def __init__(self, floor, elements, distance):
        self.floor = floor
        self.elements = elements
        self.distance = distance
        self.guid = None

    @property
    def node(self):
        """Unique state identification"""
        # Lazily generate in case the state was invalid and this is unnecessary
        if not self.guid:
            # Order the generator/chip pairs, the names are irrelevant only the positions
            elem = ''.join(sorted('{}{}'.format(*x) for x in self.elements.values()))
            self.guid = str(self.floor) + elem
        return self.guid

    @property
    def done(self):
        """Check if the state is in the required end state"""
        # All generators and chips are on the 3rd floor
        return all(floor == 3 for floors in self.elements.values() for floor in floors)

    @property
    def valid(self):
        """Is this state valid?"""
        # Every chip must be with its generator or not on the same floor as another generator
        for element in self.elements.values():
            if element[GENERATOR] != element[CHIP] and \
                any(other[GENERATOR] == element[CHIP] for other in self.elements.values()):
                return False
        return True

    @property
    def moves(self):
        """Generator to return valid moves"""

        # Collect all generators and chips on this floor as a tuple of element and type
        g = [(x, GENERATOR) for x, y in self.elements.items() if y[GENERATOR] == self.floor]
        c = [(x, CHIP) for x, y in self.elements.items() if y[CHIP] == self.floor]

        # Create a list of possible moves
        moves = list(itertools.permutations(g, 1)) + \
                list(itertools.permutations(c, 1)) + \
                list(itertools.combinations(g + c, 2))

        # Move up and down a floor
        for i in (1, -1):
            # Reject invalid floors here for performance reasons
            if self.floor + i not in range(0, 4):
                continue
            # For each move...
            for move in moves:
                # Copy the state and move the selected items
                elements = copy.deepcopy(self.elements)
                for name, typ in move:
                    elements[name][typ] += i
                # Create the new state and yield it if valid
                state = State(self.floor + i, elements, self.distance + 1)
                if state.valid:
                    yield state


def main():
    """A* Breadth first search"""

    state = State(0, INPUT, 0)

    # O(1) insert and deletion
    queue = collections.deque()
    queue.append(state)

    # O(log N) search
    ready = set()
    ready.add(state.node)

    seen = set()

    while queue:
        u = queue.popleft()
        ready.remove(u.node)
        if u.done:
            break
        if u.node in seen:
            continue
        seen.add(u.node)
        for m in u.moves:
            if m.node not in seen and m.node not in ready:
                queue.append(m)
                ready.add(m.node)

    print u.distance

if __name__ == '__main__':
    main()

# vi: ts=4 et:
