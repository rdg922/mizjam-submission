extends CanvasLayer


onready var heart = preload("res://player/heart_sprite.tscn")  

var width = 80

func _ready():
	update_health(5)
	Globals.health = self;
	print("Yuh")

func update_health(value: float):
	# Delete all children
	for node in get_children():
		node.queue_free()
	
	var x = 0;
	var ceiled = ceil(value)
	var last;
	for i in range(ceiled):
		var inst = heart.instance()
		add_child(inst)
		inst.position.x = x
		x += width
		last = inst
		
	if ceiled - value == 0.5 and last:
		last.frame = 0
		
