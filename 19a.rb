#!/usr/bin/ruby

input = 3004953

class Node
  attr_accessor :prev, :next, :id

  def initialize(id = -1)
    @id = id
  end
end

class List
  def initialize
    @head = Node.new
    @tail = Node.new
    @head.next = @tail
    @tail.prev = @head
    @size = 0
  end

  def push(id)
    n = Node.new(id)
    n.next = @tail
    n.prev = @tail.prev
    @tail.prev.next = n
    @tail.prev = n
    @size += 1
  end

  def delete(n)
    n.ptr.prev.next = n.ptr.next
    n.ptr.next.prev = n.ptr.prev
    @size -= 1
  end

  def first
    @head.next
  end

  def last
    @tail
  end

  def size
    @size
  end
end

class CyclicIterator
  def initialize(list, ptr = nil)
    @list = list
    @ptr = ptr || list.first
  end

  def ptr
    @ptr
  end

  def next
    ptr = @ptr.next
    ptr = @list.first if ptr == @list.last
    CyclicIterator.new(@list, ptr)
  end

  def next!
    @ptr = @ptr.next
    @ptr = @list.first if @ptr == @list.last
  end
end

# Model this puzzle on a linked list for O(1) delete
# Array#delete_at is way too slow
l = List.new
(1..input).each{|i| l.push(i)}

# Point to the current elf
i = CyclicIterator.new(l)

until l.size == 1
  # Move to the next elf and delete it
  l.delete(i.next)

  # Move on
  i.next!
end

puts l.first.id
