extends Panel

var style = StyleBoxFlat.new()

func _ready():
	# The Panel doc tells you which style names there are
	set_process(true)
	# Set the style for the Panel
	set_custom_minimum_size(Vector2(100, 100))
	add_theme_stylebox_override("panel", style)

func _process(delta):
	# Some basic code animation
	style.bg_color = Color(1, 1, 1) # Set background color to white
