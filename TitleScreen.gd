extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextEdit.text = "Enter Seed Here:"

func _on_TextEdit_focus_entered():
	if $TextEdit.text == "Enter Seed Here:":
		$TextEdit.text = ""



func _on_Button_button_up():
	if $TextEdit.text == "Enter Seed Here:":
		Globals.SEED = (hash(randf() * 100000))
	else:
		Globals.SEED = (hash($TextEdit.text))
	
	get_tree().call_deferred("change_scene", ("res://maps/dungeon_generator.tscn"))
