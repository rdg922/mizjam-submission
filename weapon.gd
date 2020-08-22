extends Area2D


class_name Weapon

export(float) var damage;
var knockback;
var cooldown = 10;

var weakness;


func set_state(player):
	player.state = player.STATES.MID_ATTACK
	player.attack_timer = cooldown

func use():
	pass
