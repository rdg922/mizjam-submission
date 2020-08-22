extends StaticBody2D

export(Directions.DIRECTIONS) var direction
export(float) var spawn_time;

var timer = spawn_time;

var projectile = load("res://projectile/projectile.tscn")

func _ready():
	
	$Sprite.frame_coords.y = direction

func _physics_process(delta):
	
	timer -= delta
	if timer <= 0:
		var p = projectile.instance();
		p.direction = direction
		get_tree().get_root().add_child(p)
		p.global_position = global_position + (Directions.direction_to_vector[direction] * 72)
		
#		p._ready()
		timer = spawn_time
