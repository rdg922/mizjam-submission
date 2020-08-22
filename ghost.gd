extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("startup")
	
	if randf() > .75:
		var inst = load("res://objects/potion.tscn").instance()
		get_parent().call_deferred("add_child", inst)
		inst.position = position + Vector2(0, 16)



func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("idle")
	pass # Replace with function body.
