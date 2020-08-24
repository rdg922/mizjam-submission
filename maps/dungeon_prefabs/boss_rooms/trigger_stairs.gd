extends Node2D

var boss_count = 0 setget remove_boss;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func remove_boss(value):
	boss_count = value
	if boss_count == 0:
		var stair = load("res://stair_down.tscn").instance()
		add_child(stair)
		stair.global_position = global_position + Vector2(1280/2, 720/2)
