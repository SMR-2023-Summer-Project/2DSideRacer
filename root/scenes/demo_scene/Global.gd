# author: Tolib
extends Node


# Called when the node enters the scene tree for the first time.
var spawn_point = Vector2(-496,32)#makes a global spawnpoint

func updated_spawn(new_point):#Makes a function to change the spawnpoint
	spawn_point = new_point
