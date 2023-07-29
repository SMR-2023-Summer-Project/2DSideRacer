
# Author: Hasan
# the panel for the map selector

extends Panel

var style = StyleBoxFlat.new()

func _ready():
	set_process(true)
	
	style.bg_color = Color(0, 0, 0, 0.5)
	
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	
	add_theme_stylebox_override("panel", style)

func _process(delta):
	# Some basic code animation
	# You can add more animation or logic here
	pass
