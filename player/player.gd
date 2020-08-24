extends KinematicBody2D

class_name Player

const SPEED = 500;


var current_color = 0;
# Called when the node enters the scene tree for the first time.

enum STATES {IDLE, WALK, CAN_DODGE, DODGED, HIT, MID_ATTACK, INVULNERABLE}
var state = STATES.IDLE


const HIT_TIMER_RESET = .45;
const KNOCKBACK_FALLOFF = 3500;

const INVULNERABLILITY_RESET = 1;
var invulnerablitiy_timer = 0;

var hit_direction;
var hit_timer;
var hit_knockback;

const ATTACK_TIMER_RESET = 10;
var attack_timer = 10

const DASH_TIMER_RESET = .75;
const DASH_SPEED = 100000
var dash_timer = 0;
var dash_requisite; 

onready var inventory = $inventory
onready var weapons = inventory.get_children()
onready var weapon_count = weapons
var current_weapon_index = 0;

const MAX_HEALTH = 5;
var health = MAX_HEALTH setget set_health;


var have_key = false;

var the_final_straw = 5;
var THE_FINAL_STRAW = 5;

var is_moving = .05;

func _ready():
	print(Globals.weapons)
	if Globals.weapons != null:
		get_node("inventory").queue_free()
		inventory = (Globals.weapons)
		add_child(inventory)
		inventory.name = "inventory"
	Globals.player = self
func _process(delta):
#	print(state)

	if !$AudioStreamPlayer2D.playing and get_input() != Vector2.ZERO:
		$AudioStreamPlayer2D.play()
		is_moving = .05
	if  get_input() == Vector2.ZERO:
		is_moving -= delta
		if is_moving < 0:
			$AudioStreamPlayer2D.playing = false

	if (Input.is_action_pressed("test")):
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	else:
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
	

	if !( state == STATES.WALK or state == STATES.HIT or state == STATES.MID_ATTACK or state == STATES.INVULNERABLE):
		return
	
	var direction = get_input()
	if direction != Vector2.ZERO:
		match(direction):
			Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN:
				if(Directions.vector_to_directions.has(direction)):
					current_color = Directions.vector_to_directions[direction]
			_:
				pass
		
		$AnimationPlayer.play("walk")
		if direction.x < 0:
			$Sprite.flip_h = true
		elif direction.x > 0:
			$Sprite.flip_h = false
		
		$Sprite.frame_coords.y = current_color
	else:
		$AnimationPlayer.stop()
		$Sprite.frame_coords.x = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_pressed("test"):
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	else:
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
	
#	print(invulnerablitiy_timer)
	
	var old_timer =  invulnerablitiy_timer
	
	var input = get_input()
	match state:
		STATES.IDLE:
			if input:
				state = STATES.WALK
				
			loop_can_attack()
			loop_weapon_direction()
		STATES.WALK:
			state_walk()
			
			loop_can_attack()
			loop_weapon_direction()
			loop_weapon_color()
			loop_can_switch_weapons()
			
		STATES.CAN_DODGE:
			state_walk()
			state_mid_hit(delta)
			
			loop_can_attack()
			loop_weapon_direction()
#			print("can_dodge")
		STATES.DODGED:
			state_dodge(delta)
#			print("dodgine")
		STATES.HIT:
			state_hit(delta)
		STATES.MID_ATTACK:
			state_walk()
			loop_weapon_direction()
		STATES.INVULNERABLE:
			state_invulnerable()
			state_walk()
			
			loop_can_attack()
			loop_weapon_direction()
			loop_can_switch_weapons()
	
	var diff = invulnerablitiy_timer - old_timer
	if diff != 0:
		the_final_straw -= delta
	
	if the_final_straw <= 0:
		state = STATES.WALK
		the_final_straw = THE_FINAL_STRAW
		if(has_node("flash")):
			get_node("flash").queue_free()

func set_health(new_value):
	health = new_value
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	Globals.health.update_health(health)

func state_invulnerable():
	if invulnerablitiy_timer <= 0:
		state = STATES.WALK
		if has_node("flash"): 
			$flash.queue_free()
		return
	invulnerablitiy_timer -= get_physics_process_delta_time()

func state_dodge(delta):
	move_and_slide(dash_requisite * DASH_SPEED)
	dash_timer -= delta
	if dash_timer <= 0:
		state = STATES.WALK

func state_mid_hit(delta):
	var dash_left = Input.is_action_just_pressed("LEFT") and dash_requisite == Vector2.LEFT
	var dash_right = Input.is_action_just_pressed("RIGHT") and dash_requisite == Vector2.RIGHT
	var dash_up = Input.is_action_just_pressed("UP") and dash_requisite == Vector2.UP
	var dash_down = Input.is_action_just_pressed("DOWN") and dash_requisite == Vector2.DOWN
	

	
	if dash_left or dash_right or dash_up or dash_down:
		state = STATES.DODGED
		dash_timer = DASH_TIMER_RESET

func get_input() -> Vector2:
	var xdir = int(Input.is_action_pressed("RIGHT")) - int(Input.is_action_pressed("LEFT"))
	var ydir = int(Input.is_action_pressed("DOWN")) - int(Input.is_action_pressed("UP"))
		
	var direction = Vector2(xdir, ydir).normalized()
	return direction
	
func state_walk():
	var direction = get_input()	
	move_and_slide(direction * SPEED)

func hit(damage, direction, knockback):
	get_parent().get_node("camera").shake(.2, 30, 15)
	
	if (has_node("flash") or state == STATES.HIT or state == STATES.INVULNERABLE):
		return
	
	state = STATES.HIT
	hit_timer = HIT_TIMER_RESET
	hit_direction = direction
	hit_knockback = knockback
	
	health -= damage;
	Globals.health.update_health(health);
	
	var invulnerable_flash = load("res://player/hit_flash.tscn").instance()
	invulnerable_flash.name = "flash"
	add_child(invulnerable_flash)

	

func set_invulnerable():
	invulnerablitiy_timer = INVULNERABLILITY_RESET
	
	state = STATES.INVULNERABLE
	if health == 0:
		die()

func die():
	var instance = load("res://player/death.tscn").instance()
	get_parent().add_child(instance)
	instance.global_position = global_position
	instance.timer = 10
	queue_free()

func state_hit(delta):
	hit_timer -= delta
	hit_knockback -= KNOCKBACK_FALLOFF * delta
	if hit_timer <= 0 || hit_knockback <= 0:
		set_invulnerable()
	move_and_slide(hit_direction * hit_knockback)
	
	

func use_item():
	inventory.get_child(current_weapon_index).use_item(self)
	pass


func loop_weapon_direction():
	inventory.rotation = global_position.angle_to_point(get_global_mouse_position()) + PI

	for node in inventory.get_children():
		if node is Key:
			node.get_node("Sprite").flip_v = inventory.rotation_degrees < 270 and inventory.rotation_degrees > 90
	
	pass

func get_class():
	return "Player"

func loop_weapon_color():
	return

func loop_can_attack():
	if(Input.is_action_just_pressed("M1")):
		use_item()
		$AudioStreamPlayer2D2.play()
	
func loop_can_switch_weapons():
	if(Input.is_action_just_pressed("M2") and !have_key):
		current_weapon_index += 1
		if current_weapon_index >= len(inventory.get_children()):
			current_weapon_index = 0
		for i in range(len(inventory.get_children())):
			if i == current_weapon_index:
				inventory.get_children()[i].show()
			else:
				inventory.get_children()[i].hide()
	if(have_key and Input.is_action_just_pressed("M2")):
		for item in inventory.get_children():
			if item is Key:
				item.alt_use_item(self)
	if(have_key and Input.is_action_just_pressed("M1")):
		for item in inventory.get_children():
			if item is Key:
				item.use_item(self)
				
