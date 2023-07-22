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

func _debug ():
	if Global.real_level:
		var marker = create_player_marker("You")
		
		marker.set_inactive()
		
		var max_time = 10
		var start = Time.get_unix_time_from_system()
		
		await play_countdown(3)
		
		marker.set_active()
		
		var x_position = 0
		var goal = 60
		
		while true:
			var current = Time.get_unix_time_from_system()
			var delta_time = current - start
			var game_time = clampf(max_time - delta_time, 0, max_time)
		
			set_remaining_time(game_time)
		
			if game_time == 0:
				break
		
			x_position += randf()
			x_position = clampf(x_position, 0, goal)
			
			marker.set_progress(x_position / goal)
			
			await Global.wait(0.15)
		
		marker.set_inactive()
		
		time_remaining.hide()
		player_progress.hide()
		
		await show_finished()
		
		await Global.wait(3)
		
		await hide_finished()
	else:
		print("This is the lobby")

func _ready():
	time_remaining.hide()
	player_progress.hide()
	countdown.hide()
	
	await _debug()
