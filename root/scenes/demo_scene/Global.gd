# author: Tolib
extends Node


# Called when the node enters the scene tree for the first time.
var spawn_point = Vector2(-496,32)

func updated_spawn(new_point):
	spawn_point = new_point
