extends Area2D


class_name Key

var collected = false

var collectable = true

var new_pos;

func _on_Node2D_body_entered(body):
	if body.get_class() == "Player" and !collected and collectable:
		get_parent().call_deferred("remove_child", self)
		body.inventory.call_deferred("add_child", self)
#		add_child(self)
		position = Vector2(64, 0)
		collected = true
		for i in range(len(body.inventory.get_children())):
			body.inventory.get_children()[i].hide()
		self.show()
		collected = true
		body.have_key = true
		$AudioStreamPlayer2D.play()

func open():
	if len(get_overlapping_bodies()) > 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("wall"):
				body.get_parent().queue_free()
				var player = get_parent().get_parent()
				player.have_key = false
				player.inventory.get_children().erase(self)
				player.current_weapon_index = 0;
				for i in range(len(player.inventory.get_children())):
					if i == player.current_weapon_index:
						player.inventory.get_children()[i].show()
					else:
						player.inventory.get_children()[i].hide()
				queue_free()
				
				


func use_item(player):
	$AnimationPlayer.play("use")
#	$AudioStreamPlayer2D.stream = load("res://sfx/doorClose_1.ogg")
#	$AudioStreamPlayer2D.play()
	pass

func alt_use_item(player):
	player.have_key = false
	collected = false;
	collectable = false
	new_pos = get_parent().get_parent().global_position
	get_parent().call_deferred("remove_child", self)
	get_tree().get_root().call_deferred("add_child", self)
	


func _on_Node2D_tree_entered():
	if new_pos:
		global_position = new_pos
		new_pos = null


func _on_Node2D_body_exited(body):
	if body.get_class() == "Player":
		collectable = true
	
	pass # Replace with function body.
