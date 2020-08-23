extends KinematicBody2D


class_name Enemy

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var area = $Area2D

var current_anim = "move"

var STATES = {"IDLE": 0, "PLAYER_FOUND": 1, "HIT": 2}
var state = STATES.IDLE

var SPEED = 140

var target;

var knockback_resistance = 7500;
var knockback_speed;
var knockback_direction;

var health = 4
# IDLE
onready var next_position = global_position;
var ROAM_DISTANCE = 500

var attack_range = 70

onready var default_position = global_position

func get_class():
	return "Enemy"

# Check if in screen
func _process(delta):
	var new_state = Globals.camera.get_grid_pos(global_position) == Globals.camera.get_grid_pos(Globals.camera.global_position)
	
	if is_physics_processing() != new_state:
		global_position = default_position
		set_physics_process(new_state)
	
		
	
func _physics_process(delta):
	state_machine(delta)

func state_machine(delta):
	match(state):
		STATES.IDLE:
			loop_idle(true)
			var target = loop_check_player()
			if target:
				state = STATES.PLAYER_FOUND
		STATES.PLAYER_FOUND:
			loop_player_chase()
			var target = loop_check_player()
			if !target:
				state = STATES.IDLE
		STATES.HIT:
			loop_hit()	

func loop_idle(animation_advance = false):
	var next = move_to(next_position, 15, animation_advance)
	if(next):
		next_position = Vector2(rand_range(-ROAM_DISTANCE, ROAM_DISTANCE), rand_range(-ROAM_DISTANCE, ROAM_DISTANCE)) + global_position

func loop_check_player():
	var bodies = area.get_overlapping_bodies()
	if len(bodies) > 0:
		for body in area.get_overlapping_bodies():
			if body is Player:
				target = body
				return body
	return null

func end_hit():
	state = STATES.IDLE
	anim.assigned_animation = ("move")
	if health <= 0:
		die()
	pass

func move_to(point, maximum_distance = 15, play_animation = true) -> bool:
	
	if play_animation: anim.play("move")
	
	sprite.flip_h = !(global_position.x - point.x < 0)
	
	if((global_position - point).length() < maximum_distance):
		return true
	else:
		var velocity = global_position.direction_to(point) * SPEED
		var collision = move_and_slide(velocity)

		var direction = velocity.normalized()
		if abs(direction.x) > abs(direction.y):
			sprite.frame_coords.y = Directions.DIRECTIONS.LEFT if direction.x < 0 else Directions.DIRECTIONS.RIGHT
		if abs(direction.y) > abs(direction.x):
			sprite.frame_coords.y = Directions.DIRECTIONS.UP if direction.x < 0 else Directions.DIRECTIONS.DOWN
		if collision != velocity:
			return true
		else:
			return false


func loop_player_chase():
	if anim.assigned_animation == "attack":
		return
	
	if !player_exists():
		return
	
	var close = move_to(target.global_position, attack_range, false)
	if close:
		anim.play("attack")
	else:
		anim.play("move")

func player_exists():
	var wr = weakref(target)
	# freed
	
	var foo = target != null and wr.get_ref()
	if !foo:
		state = STATES.IDLE
	return foo

func loop_hit():
	
	knockback_speed -= knockback_resistance * get_physics_process_delta_time()
	if knockback_resistance == -1 or knockback_speed <= 0:
		end_hit()
		return
	
	move_and_slide(knockback_speed * knockback_direction)
	
	

func die():
	var ghost = load("res://ghost.tscn").instance()
	get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.get_node("sprite").frame_coords.y = sprite.frame_coords.y
	Globals.enemies_killed += 1
	queue_free()
	
func hit(damage, direction, knockback):
	state = STATES.HIT
	knockback_speed = knockback;
	knockback_direction = direction
	health -= damage
	anim.play("hit")
	Globals.camera.shake(.2, 30, 15)

func attack():
	pass

func end_attack():
	anim.play("move")
	state = STATES.IDLE

func get_direction_to_player():
	
	if !player_exists():
		return
	
	var dir_to_player = (target.global_position - global_position).normalized()
	if abs(dir_to_player.y) < abs(dir_to_player.x):
		if dir_to_player.x < 0:
			return Directions.DIRECTIONS.LEFT
		else:
			return Directions.DIRECTIONS.RIGHT
	if abs(dir_to_player.x) < abs(dir_to_player.y):
		if dir_to_player.y < 0:
			return Directions.DIRECTIONS.UP
		else:
			return Directions.DIRECTIONS.DOWN
