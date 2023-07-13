# author: Tolib, Habib
extends Node


# Called when the node enters the scene tree for the first time.
var spawn_point = Vector2(-496,32)#makes a global spawnpoint

func updated_spawn(new_point):#Makes a function to change the spawnpoint
	spawn_point = new_point

func is_server() -> bool:
	# returns true if the calling instance is the
	# current host of a server
	return multiplayer.get_unique_id() == 1

func is_client() -> bool:
	# returns true if the calling instance is a client
	return not is_server()

func wait(seconds: float) -> void:
	# pauses script execution for the given time
	# in seconds using a timer
	
	var timer = Timer.new()
	
	timer.one_shot = true # timer should only run once
	timer.wait_time = seconds
	
	add_child(timer) # must be parented to the tree for events to trigger
	timer.start()
	
	# after timeout, cleanup
	timer.timeout.connect(func(): remove_child(timer))
	
	await timer.timeout
