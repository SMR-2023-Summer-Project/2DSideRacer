extends ColorRect

class_name BackButton
# Called when the node enters the scene tree for the first time.
var image : TextureRect
var closeScene = false
var button : TextureButton
var previousScene = ""
#var bgOffset = position - Vector2(-159,-79) 
var butOffset = Vector2(-36,-20) 
func _ready():
	color = 'black'
	button = TextureButton.new()
	image = TextureRect.new()
	button.position = position + butOffset
	image.position = position + Vector2(-165,-90) 
	size = Vector2(225,115)
	scale = Vector2(.75,.75)
	button.size = Vector2(219,109)
	image.scale = Vector2(.5,.6)
	image.texture = load('res://root/assets/sprites/Menus/back_button.png')
	add_child(image)
	add_child(button)
	button.pressed.connect(_on_back_button_pressed)
	button.mouse_entered.connect(_on_back_button_mouse_entered)
	button.mouse_exited.connect(_on_back_button_mouse_exited)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	


	


func _on_back_button_pressed():
	if !closeScene:
		get_tree().change_scene_to_file(previousScene)
	else:
		get_parent().queue_free()

func _on_back_button_mouse_entered():
	self.color = 'white'
	self.scale = Vector2(1,1)


func _on_back_button_mouse_exited():
	self.color = 'black'
	self.scale = Vector2(.75,.75)
