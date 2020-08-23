extends Weapon



onready var anim = $AnimationPlayer

export var color = 01

var is_collected = false;

func _init():
	knockback = 2000;



# Called when the node enters the scene tree for the first time.
func _ready():
	cooldown = 10000 # Cooldown happens at end of animation player
	$Sprite.frame_coords.y = color
	if get_parent().get_parent().get_class() == "Player":
		is_collected = true
	else:
		connect("body_entered", self, "_on_Sword_body_entered")


var player
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Haha computer go brrr
func use_item(p):
	player = p
	$AnimationPlayer.play("attack")
	.set_state(p)

func _on_AnimationPlayer_animation_finished(anim_name):
	player.state = player.STATES.WALK
	pass # Replace with function body.

func attack():
	for body in get_overlapping_bodies():
		if body.get_class() == "Enemy":
			var direction = (body.global_position - get_parent().global_position).normalized()
			body.hit(damage, direction, knockback)
			
		if body.is_in_group("dungeon_lock") and body.get_node("Sprite").frame_coords.y == $Sprite.frame_coords.y:
			body.get_node("AnimationPlayer").play("delete")
		

func knockback():
	for body in get_overlapping_bodies():
		if body.get_class() == "Enemy":
			var direction = (body.global_position - get_parent().global_position).normalized()
			body.hit(damage, direction, 1)
			
		if body.is_in_group("dungeon_lock") and body.get_node("Sprite").frame_coords.y == $Sprite.frame_coords.y:
			body.get_node("AnimationPlayer").play("delete")	


func _on_Sword_body_entered(body):
	if body.get_class() == "Player" and !is_collected:
		is_collected = true
		get_parent().call_deferred("remove_child", self)
		body.inventory.call_deferred("add_child", self)
		position = Vector2(13, 0)
		rotation = 0
		hide()
