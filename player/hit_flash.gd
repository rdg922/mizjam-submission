extends Sprite


export var flash_time = .5;
var flash_timer = flash_time;

var max_time_alive = 1

# Called when the node enters the scene tree for the first time.

func _ready():
#	print("yuh")
	pass
func queue_free():
#	print('dead')
	.queue_free()

func _process(delta):
	if flash_timer <= 0:
		flash_timer = flash_time
		frame = !(frame)
	flash_timer -= delta
	max_time_alive -= delta
	if max_time_alive <= 0:
		queue_free()
