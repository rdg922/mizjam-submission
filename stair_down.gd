extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("stair instantiated")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_Area2D_body_entered(body):
	if body is Player:
		Globals.weapons = body.get_node("inventory")
		body.remove_child(Globals.weapons)
		Globals.SEED += 1
		Globals.theme += 1
		if Globals.theme > 2:
			get_tree().change_scene("res://You Win!.tscn")
		else:
			get_tree().call_deferred("change_scene", "res://maps/dungeon_generator.tscn")
