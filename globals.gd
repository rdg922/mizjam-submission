extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var camera;
var health;

var player;

var enemies_killed = 0;

var SEED;

var bosses_done = []
var theme = 0;

var weapons;

var weapons_found = [];

func reset():
	weapons = null;
	weapons_found = []
	bosses_done = []
#	randomize()
	SEED = rand_range(1,100000000);
	camera = null;
	health = null
	enemies_killed = 0;
	theme = 0
	player = null

