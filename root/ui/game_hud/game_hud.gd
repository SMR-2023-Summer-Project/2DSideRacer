# Author: Habib

extends Control

@onready var time_remaining = $TimeRemaining
@onready var countdown = $Countdown
@onready var player_progress = $PlayerProgress

func set_remaining_time (duration_seconds: int) -> void:
	# sets the amount of time that is visible
	# above the screen in the game HUD
	
	var minutes = floor(duration_seconds / 60)
	var seconds = duration_seconds % 60
	
	# format string minutes & seconds
	var text_content = "%02d:%02d" % [minutes, seconds]
	
	time_remaining.text = text_content

func _debug_do_test_countdown():
	# tests the countdown functionality and remaining time
	var time = 600
	
	while time > 0:
		set_remaining_time(time)
		time -= 1
		await Global.wait(1)

func _debug_do_test_player_progress(name: String, is_local: bool):
	# tests the player progress functionality
	
	var test_marker = player_progress.create_marker(name)

	var x_position = 0.0
	var goal_position = 50.0
	
	if not is_local:
		test_marker.set_inactive()

	while x_position != goal_position:
		x_position += randf()
		x_position = clampf(x_position, 0, goal_position)
		test_marker.set_progress(x_position / goal_position)
		
		# randomly pause for testing
		if randf() < 0.05:
			await Global.wait(1 + randi() % 3)
		
		await Global.wait(0.2)

func _ready():
	await countdown.start(3)
	
	_debug_do_test_player_progress("Player2", false)
	_debug_do_test_player_progress("Player3", false)
	_debug_do_test_player_progress("You", true)
	
	_debug_do_test_countdown()
