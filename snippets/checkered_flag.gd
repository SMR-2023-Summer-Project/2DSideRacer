# Author: Habib
extends HBoxContainer

const FLAG_WIDTH = 410

@onready var flag_template: Control = $Flag
@export var SCROLL_SPEED = 2

var total_scroll = 0
var current_flags = 1
var flags = [flag_template]

func scroll(ammount: int) -> void:
	# scrolls the flag texture along the screen by
	# the given ammount in pixels
	
	total_scroll += ammount
	
	while abs(total_scroll) > FLAG_WIDTH:
		var first_flag = flags.pop_front()
		
		remove_child(first_flag)
		add_child(first_flag)
		
		flags.append(first_flag)
		
		total_scroll %= FLAG_WIDTH
	
	position = Vector2(-total_scroll, position.y)

func flags_for_screen() -> int:
	# returns the total ammount of flags needed to cover
	# the horizontal width of the screen
	
	var window_size: Vector2i = get_window().size
	var window_width = window_size.x
	
	return ceil(window_width / FLAG_WIDTH) + 2

func reconcile_flag_ammount(goal: int) -> void:
	# changes the flag ammount to reach the
	# specified goal ammount
	
	if current_flags < goal:
		var flags_to_add = goal - current_flags

		for i in range(flags_to_add):
			var flag = flag_template.duplicate()
			
			add_child(flag)
			flags.append(flag)
			
			current_flags += 1
	elif current_flags > goal:
		var start_index = len(flags) - 1
		var end_index = start_index - goal
		
		var removing_flags = flags.slice(start_index, end_index, -1)
		
		# TODO: Reduce ammount!

func _process(delta: float):
	var expected_flag_ammount = flags_for_screen()
	
	if expected_flag_ammount != current_flags:
		reconcile_flag_ammount(expected_flag_ammount)
	
	scroll(SCROLL_SPEED)
