#!/usr/bin/python

import collections


class Bot(list):
    # Class reference to the ready list
    ready = None

    # A bot can be constructed with one chip if instantiated by a 'value'
    # command, or none if instantiated by a 'bot' command
    def __init__(self, identity, *chips):
        super(Bot, self).__init__(chips)
        self.identity = identity
        self.instructions = []

    # Override append which also adds the bot to the ready list if
    # it has both of its chips
    def append(self, chip):
        super(Bot, self).append(chip)
        if len(self) == 2:
            self.ready.append(self)

    # Buffer up instructions
    def add_instruction(self, instruction):
        self.instructions.append(instruction)

    def __call__(self):
        for instruction in self.instructions:
            instruction(self)


class BotDict(collections.defaultdict):
    def __missing__(self, key):
        self[key] = self.default_factory(key)
        return self[key]


class Instruction(object):
    # Class reference to our bots and outputs
    bots = None
    outputs = None

    # Stash our target and operation
    def __init__(self, target, op):
        self.target = target
        self.op = op


class BotInstruction(Instruction):
    # Pass the value determined by the operation to a bot
    def __call__(self, bot):
        self.bots[self.target].append(self.op(*bot))


class OutputInstruction(Instruction):
    # Pass the value determined by the operation to an output
    def __call__(self, bot):
        self.outputs[self.target] = self.op(*bot)


def main():
    # Ready list for bots with all their chips
    ready = collections.deque()

    # Attach the ready list to the bot class
    Bot.ready = ready

    # Bots are a dictionary of identity to Bot objects
    bots = BotDict(Bot)

    # Ouputs are a dictionary of identity to value
    outputs = {}

    # Attach the bots and outputs to the instruction class so it can
    # emit to them
    Instruction.bots = bots
    Instruction.outputs = outputs

    # Adds an instruction to a bot for execution when all chips are collected
    def add_instruction(bot, what, where, how):
        cls = {'bot': BotInstruction, 'output': OutputInstruction}[what]
        op = {'high': max, 'low': min}[how]
        bots[bot].add_instruction(cls(where, op))

    # Parse all the input first to get us in a stable state
    # this will populate bots attach instructions and add candidates to the
    # ready list
    data = [x.split() for x in open('10.in')]
    for line in data:
        if line[0] == 'value':
            # Assert a value on a bot
            bot = int(line[5])
            value = int(line[1])
            bots[bot].append(value)
        else:
            # Add an instructions to the bot
            bot = int(line[1])
            add_instruction(bot, line[5], int(line[6]), line[3])
            add_instruction(bot, line[10], int(line[11]), line[8])

    # While the ready list is populated, remove a bot and propagate
    # its values to the targets identifed by the instructions
    while ready:
        bot = ready.popleft()
        # Answer is the first bot to contain 17 and 61 as inputs
        if all(x in [17, 61] for x in bot):
            print bot.identity
            break
        bot()


if __name__ == '__main__':
    main()

# vi: ts=4 et:
