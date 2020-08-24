extends Control


var options = [
	"Get Pranked",
	"You Lose",
	"You Didn't Dodge",
	"It's a secret to everybody",
	"Game Over",
	"You Won... Or did you?"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = options[floor(rand_range(0, len(options)))]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	Globals.reset()
	get_tree().change_scene("res://TitleScreen.tscn")
	queue_free()
	pass # Replace with function body.
	


func _on_Button2_button_up():
	Globals.reset()
	get_tree().change_scene("res://maps/dungeon_generator.tscn")
	queue_free()
	pass # Replace with function body.
