extends Projectile


class_name DoubleProjectile

func _ready():
	sprite.frame_coords.y = 1

func _physics_process(delta):
	global_position += move_dir * delta * speed
	
	if player != null and player.current_color != direction:
		player.hit(damage, move_dir, knockback)
		queue_free()
	elif player != null and player.current_color == direction and player.state != player.STATES.CAN_DODGE and player.state != player.STATES.HIT :
		player.state = player.STATES.CAN_DODGE
		player.dash_requisite = move_dir
		print("updated player state")
	elif player != null and player.state == player.STATES.DODGED:
		queue_free()

func _body_exit(node: Node2D):
	if node is Player and node.state != node.STATES.DODGED:
		player.hit(damage, move_dir, knockback)
		queue_free()
