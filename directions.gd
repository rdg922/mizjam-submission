extends Node


enum DIRECTIONS {LEFT = 0, RIGHT = 1, UP = 2, DOWN = 3} 

var vector_to_directions = {}
var direction_to_vector = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	vector_to_directions[Vector2(-1,0)] = 0
	vector_to_directions[Vector2(1,0)] = 1
	vector_to_directions[Vector2(0,-1)] = 2
	vector_to_directions[Vector2(0,1)] = 3

	direction_to_vector[0] = Vector2(-1,0)
	direction_to_vector[1] = Vector2(1,0)
	direction_to_vector[2] = Vector2(0,-1)
	direction_to_vector[3] = Vector2(0,1)
