extends Enemy

var projectile = load("res://projectile/projectile.tscn")
#
func _init():
	SPEED = 300
	health = 4.5
	attack_range = 1000

func loop_idle(animation_advance = false):
	var next = move_to(next_position, 15, animation_advance)
	if(next):
		next_position = Vector2(rand_range(-ROAM_DISTANCE, ROAM_DISTANCE), rand_range(-ROAM_DISTANCE, ROAM_DISTANCE)) + global_position

func state_machine(delta):
	match(state):
		STATES.IDLE:
			loop_idle(true)
			var target = loop_check_player()
			if target:
				state = STATES.PLAYER_FOUND
		STATES.PLAYER_FOUND:
			loop_player_chase()
		STATES.HIT:
			loop_hit()


func loop_attack():
	.loop_attack()
	move_to(next_position)


func attack():
	var direction = get_direction_to_player()
	
	if direction == null:
		return
	
	var p =  projectile.instance()
	p.direction = direction
	get_parent().add_child(p)
	p.global_position = global_position + Directions.direction_to_vector[direction] * 64
	

