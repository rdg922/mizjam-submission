extends KinematicBody2D


 
var timer;

# Called when the node enters the scene tree for the first time.




func _on_Timer_timeout():
	var screen : Control = load("res://You Lose!.tscn").instance()
	get_tree().get_root().add_child(screen)
	screen.rect_global_position = Globals.camera.global_position
	pass # Replace with function body.
