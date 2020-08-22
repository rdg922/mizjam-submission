extends Area2D



class_name Projectile

export var damage = .5
export(Directions.DIRECTIONS) var direction = Directions.DIRECTIONS.LEFT
export var speed = 400
export var knockback = 1000
onready var sprite = $Sprite

var player;

var move_dir;

var timer = 10;

func _ready():
#	print(direction)
	move_dir = Directions.direction_to_vector[direction]
	connect("body_entered", self, "_body_connect")
	connect("body_exited", self, "_body_exit")
	sprite.frame = direction

func _body_connect(node: Node2D):
	if node is Player:
		player = node
	elif node is Enemy:
		return
	else:
		queue_free()

func _body_exit(node: Node2D):
	if node is Player:
		player = null

func _physics_process(delta):
	global_position += move_dir * delta * speed
	
	if player == null:
		return
	
	var in_hittable_state = !player.has_node("flash")
	if player.current_color != direction and in_hittable_state:
		print(player.state == player.STATES.HIT)
		player.hit(damage, move_dir, knockback)
		queue_free()
	
	timer -= delta
	if timer < 0: queue_free()
