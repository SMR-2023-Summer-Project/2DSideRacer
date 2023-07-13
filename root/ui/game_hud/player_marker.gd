# Author: Habib

extends Control

var parent_size = Vector2(952, 5)

@export var progress: float = 0.0
var current_tween: Tween = null

@onready var indicator = $Indicator
@onready var player_name = $PlayerName

func set_player_name(plr_name: String) -> void:
	# sets the name that is visible under
	# the player marker
	
	name = plr_name
	player_name.text = plr_name

func set_progress(dist_to_goal: float, do_tween: bool = true) -> void:
	# accepts a value between 0 and 1 representing the player's
	# distance to goal, and places the marker accordingly
	# accepts an aditional optional boolean to specify whether to animate it or not
	
	if current_tween != null:
		current_tween.kill()
	
	# multiply progress into size to get end goal
	var goal_position = Vector2(parent_size.x * dist_to_goal, 0)
	
	if do_tween:
		# tween smoothly to new position
		current_tween = create_tween()
		current_tween.tween_property(self, "position", goal_position, 0.25)
		current_tween.set_ease(Tween.EASE_OUT)
		current_tween.set_trans(Tween.TRANS_EXPO)
	else:
		position = goal_position
	
	progress = dist_to_goal

func set_inactive():
	# visually changes the marker to a darkened
	# state signifying the player is dead/inactive
	
	indicator.color = Color(0.5, 0.5, 0.5)
	player_name.modulate.a = 0.25

func set_active():
	# changes the marker to a lightened state
	# signifying the player is active
	
	indicator.color = Color(1, 1, 0)
	player_name.modulate.a = 1

func _physics_process(delta):
	# incase window size changes, we need to update
	# size of marker
	var actual_parent_size = Vector2(get_parent().size)
	
	if parent_size != actual_parent_size:
		parent_size = actual_parent_size
		
		# reset marker position
		set_progress(progress, false)
