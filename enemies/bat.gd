extends Enemy


var projectile = load("res://projectile/projectile.tscn")



func _init():
	attack_range = 900
	health = 2;
	
func attack():
	.attack()
#	for direction in Directions.DIRECTIONS.values():
	var direction = get_direction_to_player()
	var p =  projectile.instance()
	p.direction = direction
	p.position = position + Directions.direction_to_vector[direction] * 5
	get_parent().add_child(p)

func loop_attack():
	.loop_attack()
	move_to(target.position)

func _physics_process(delta):
	loop_idle(false)
	anim.play('attack')
	
func loop_player_chase():
	if !player_exists():
		return
	if anim.assigned_animation == "attack":
		return
	anim.play("attack")
#	var close = move_to(target.global_position, attack_range, false)
	
