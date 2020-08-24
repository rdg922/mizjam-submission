extends Enemy

var projectile = load("res://projectile/projectile.tscn")


var TIMER_RESET = 1;
var timer = 1;

func _init():
	SPEED = 300
	health = 10
	attack_range = 1000

func _ready():
	get_parent().boss_count += 1

func loop_idle(animation_advance = false):
	var next = move_to(next_position, 15, animation_advance)
	if(next):
		next_position = Vector2(rand_range(-ROAM_DISTANCE, ROAM_DISTANCE), rand_range(-ROAM_DISTANCE, ROAM_DISTANCE)) + global_position

func state_machine(delta):
	match(state):
		STATES.IDLE:
			loop_idle(true)
			var target = loop_check_player()
			if target and timer <= 0:
				state = STATES.PLAYER_FOUND
			timer -= delta
		STATES.PLAYER_FOUND:
			loop_player_chase()
		STATES.HIT:
			loop_hit()


func loop_check_player():
	var bodies = area.get_overlapping_bodies()
	if len(bodies) > 0:
		for body in area.get_overlapping_bodies():
			if body is Player:
				target = body
				return body
	return null

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
	p.global_position = global_position + Directions.direction_to_vector[direction] * 128
	p.scale.x *= 3
	p.scale.y *= 3
	
func end_attack():
	timer = TIMER_RESET
	state = STATES.IDLE

func queue_free():
	get_parent().boss_count -= 1
	print(get_parent().boss_count)
	.queue_free()
