extends Enemy


var projectile = load("res://projectile/projectile.tscn")

func _init():
	health = 5
	attack_range = 150

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
func attack():
	.attack()
	for direction in Directions.DIRECTIONS.values():
		var p =  projectile.instance()
		p.direction = direction
		p.position = position + Directions.direction_to_vector[direction] * 5
		get_parent().add_child(p)

func loop_attack():
	.loop_attack()
	move_to(target.position)

