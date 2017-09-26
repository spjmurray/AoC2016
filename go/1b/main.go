package main

import (
	"fmt"
	"strings"
)

type Vector2i struct {
	x int
	y int
}

func (v *Vector2i) manhattan() int {
	tx := v.x
	if(tx < 0) {
		tx = -tx
	}
	ty := v.y
	if(ty < 0) {
		ty = -ty
	}
	return tx + ty
}

func main() {
	input := "R4, R5, L5, L5, L3, R2, R1, R1, L5, R5, R2, L1, L3, L4, R3, L1, L1, R2, R3, R3, R1, L3, L5, R3, R1, L1, R1, R2, L1, L4, L5, R4, R2, L192, R5, L2, R53, R1, L5, R73, R5, L5, R186, L3, L2, R1, R3, L3, L3, R1, L4, L2, R3, L5, R4, R3, R1, L1, R5, R2, R1, R1, R1, R3, R2, L1, R5, R1, L5, R2, L2, L4, R3, L1, R4, L5, R4, R3, L5, L3, R4, R2, L5, L5, R2, R3, R5, R4, R2, R1, L1, L5, L2, L3, L4, L5, L4, L5, L1, R3, R4, R5, R3, L5, L4, L3, L1, L4, R2, R5, R5, R4, L2, L4, R3, R1, L2, R5, L5, R1, R1, L1, L5, L5, L2, L1, R5, R2, L4, L1, R4, R3, L3, R1, R5, L1, L4, R2, L3, R5, R3, R1, L3"

	inputs := strings.Split(input, ", ")

	moves := [...]Vector2i{Vector2i{0, 1}, Vector2i{1, 0}, Vector2i{0, -1}, Vector2i{-1, 0}}

	iterator := 0

	position := Vector2i{0, 0}

	visited := map[Vector2i]bool{}

	done := false

	for _, i := range inputs {
		if done {
			break
		}

		var direction string
		var magnitude int
		fmt.Sscanf(i, "%1s%d", &direction, &magnitude)

		if direction == "R" {
			iterator += 1
		} else {
			// Warning: % is a remainder, not modulus
			iterator += 4 - 1
		}
		iterator %= 4

		for j := 0; j != magnitude; j++ {
			position.x += moves[iterator].x
			position.y += moves[iterator].y

			if _, ok := visited[position]; ok {
				done = true
				break
			}

			visited[position] = true
		}
	}

	fmt.Println(position.manhattan())
}

// vi: ts=8 noet:
