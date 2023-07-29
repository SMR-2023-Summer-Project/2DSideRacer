extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect( _on_button_pressed)
	$Button2.pressed.connect( _on_button_2_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	hide()
	get_parent().get_node('Options').texture_normal = load('res://root/assets/sprites/Menus/Pause.png')
	
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://root/ui/title_screen/title_screen.tscn")
