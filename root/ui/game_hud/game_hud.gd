# Author: Habib

extends Control
class_name GameHUD

@onready var time_remaining = $TimeRemaining
@onready var countdown = $Countdown
@onready var player_progress = $PlayerProgress
@onready var finished = $Finished

func set_remaining_time (duration_seconds: int) -> void:
	# sets the amount of time that is visible
	# above the screen in the game HUD
	
	var minutes = floor(duration_seconds / 60)
	var seconds = duration_seconds % 60
	
	# format string minutes & seconds
	var text_content = "%02d:%02d" % [minutes, seconds]
	
	time_remaining.text = text_content
	time_remaining.show()

func create_player_marker (name: String) -> Control:
	# creates a new player marker on the top ui
	# and returns it
	
	player_progress.show()
	
	return player_progress.create_marker(name)

func play_countdown (starting_number: int) -> void:
	# plays the countdown animation for the beginning
	# of a round
	
	countdown.show()
	
	await countdown.start(starting_number)

func show_finished ():
	# displays the finished gui with an animation
	
	await finished.appear()

func hide_finished ():
	# hides the finished gui
	
	await finished.disappear()

func _ready():
	time_remaining.hide()
	player_progress.hide()
	countdown.hide()
