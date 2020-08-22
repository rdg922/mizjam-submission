extends Area2D





func _on_Key_body_entered(body):
	if body.get_class() == "Player":
		body.health += 1;
		Globals.health.update_health(body.health)
		queue_free()
		
