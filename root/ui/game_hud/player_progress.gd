# Author: Habib

extends MarginContainer

@onready var marker_container = $MarkerContainer

var player_marker_scene: PackedScene = load("res://root/ui/game_hud/player_marker.tscn")
var current_markers = []

func create_marker(player_name: String) -> Control:
	# instances a new player marker object of
	# the given name and returns it
	
	var player_marker: Control = player_marker_scene.instantiate()
	
	marker_container.add_child(player_marker)
	
	player_marker.visible = true
	player_marker.set_player_name(player_name)
	
	return player_marker
