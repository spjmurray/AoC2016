package main

import (
	"fmt"
	"sort"
)

type State interface {
	// Comparable hash of the state e.g. an int
	Hash() interface{}
	// Termination state?
	Done() bool
	// Slice of the next N possible moves
	Next() []State
	// Distance travelled
	Distance() interface{}
}

const (
	GENERATOR int = iota
	CHIP
)

type elementPair struct {
	generator int
	chip      int
}

func (p *elementPair) toInt() int {
	return p.generator << 4 | p.chip
}

type elevatorState struct {
	hash     int
	floor    int
	elements []elementPair
	distance int
}

func (s *elevatorState) Hash() interface{} {
	if s.hash != 0 {
		return s.hash
	}
	i := []int{}
	for _, p := range(s.elements) {
		i = append(i, p.toInt())
	}
	sort.Ints(i)
	hash := 1 << 4 | s.floor
	for _, val := range i {
		hash <<= 8
		hash |= val
	}
	s.hash = hash
	return hash
}

func (s *elevatorState) Done() bool {
	for _, p := range s.elements {
		if p.generator != 3 || p.chip != 3 {
			return false
		}
	}
	return true
}

type schedPair struct {
	element int
	object int
}

func (s *elevatorState) deepcopy() *elevatorState {
	state := &elevatorState{floor: s.floor, elements: make([]elementPair, len(s.elements)), distance: s.distance}
	copy(state.elements, s.elements)
	return state
}

func (s *elevatorState) valid() bool {
	for _, p := range s.elements {
		if p.generator == p.chip {
			continue
		}
		for _, q := range s.elements {
			if p.chip == q.generator {
				return false
			}
		}
	}
	return true
}

func (s *elevatorState) Next() []State {
	objects := []schedPair{}
	for i, p := range s.elements {
		if p.generator == s.floor {
			objects = append(objects, schedPair{i, GENERATOR})
		}
		if p.chip == s.floor {
			objects = append(objects, schedPair{i, CHIP})
		}
	}

	movements := [...]int{-1, 1}

	states := []State{}
	for _, direction := range movements {
		floor := s.floor + direction
		if floor < 0 || floor > 3 {
			continue
		}

		for i, p := range objects {
			state := s.deepcopy()
			state.floor = floor
			state.distance += 1
			if p.object == GENERATOR {
				state.elements[p.element].generator += direction
			} else {
				state.elements[p.element].chip += direction
			}
			if state.valid() {
				states = append(states, state)
			}

			if i + 1 >= len(objects) {
				continue
			}

			for _, q := range objects[i+1:] {
				state2 := state.deepcopy()
				if q.object == GENERATOR {
					state2.elements[q.element].generator += direction
				} else {
					state2.elements[q.element].chip += direction
				}
				if state2.valid() {
					states = append(states, state2)
				}
			}
		}
	}

	return states
}

func (s *elevatorState) Distance() interface{} {
	return s.distance
}

func main() {
	s := elevatorState{elements: []elementPair{}}
	s.elements = append(s.elements, elementPair{0, 0})
	s.elements = append(s.elements, elementPair{0, 1})
	s.elements = append(s.elements, elementPair{0, 1})
	s.elements = append(s.elements, elementPair{2, 2})
	s.elements = append(s.elements, elementPair{2, 2})
	s.elements = append(s.elements, elementPair{0, 0})
	s.elements = append(s.elements, elementPair{0, 0})

	queue := []State{}
	queue = append(queue, &s)

	ready := map[interface{}]bool{}
	ready[s.Hash()] = true

	seen := map[interface{}]bool{}

	var u State

	for {
		if len(queue) == 0 {
			fmt.Println("Empty!!")
			break
		}

		u = queue[0]
		if len(queue) > 0 {
			queue = queue[1:]
		}

		if u.Done() {
			break
		}

		delete(ready, u.Hash())
		seen[u.Hash()] = true

		states := u.Next()
		for _, state := range(states) {
			if _, ok := ready[state.Hash()]; ok {
				continue
			}
			if _, ok := seen[state.Hash()]; ok {
				continue
			}
			queue = append(queue, state)
			ready[state.Hash()] = true
		}
	}

	fmt.Println(u.Distance())
}

// vi: ts=8 noet:
