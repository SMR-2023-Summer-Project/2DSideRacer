# author: Tolib, Habib
extends Node


# Called when the node enters the scene tree for the first time.
var spawn_point = Vector2(-496,32)#makes a global spawnpoint
var spawnY = 200
var mapChosen = false
var map = ''
var flag = false
var players = 0
var message = ''
#var player = ''
func updated_respawn(new_point):#Makes a function to change the spawnpoint
	spawn_point = new_point
	print('Spawn Changed to', new_point)
func updated_respawn_distance(y):#Makes a function to change the spawnpoint
	spawnY = y
func change_mapChose(chosen, chosenMap):
	mapChosen = chosen
	map = chosenMap

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

func display_player_message(new_message):
	message = new_message
	await get_tree().create_timer(5).timeout
	message = ''
