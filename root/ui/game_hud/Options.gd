extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect( _on_option_button_pressed)
	texture_normal = load('res://root/assets/sprites/Menus/Pause.png')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_option_button_pressed():
	if texture_normal == load('res://root/assets/sprites/Menus/Pause.png'):
		texture_normal = load("res://root/assets/sprites/Menus/Play.png")
		get_parent().get_node('Play options').show()
	else:
		texture_normal = load('res://root/assets/sprites/Menus/Pause.png')
		get_parent().get_node('Play options').hide()
	
