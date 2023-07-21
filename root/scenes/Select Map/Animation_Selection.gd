extends ColorRect

class_name BackButton
# Called when the node enters the scene tree for the first time.
var bg : TextureRect
var button : Button
#var bgOffset = position - Vector2(-159,-79) 
#var butOffset = position - Vector2(161,-82) 
func _ready():
	button = Button.new()
	bg = TextureRect.new()
	button.position = position
	bg.position = position
	size = Vector2(225,115)
	#button.size = Vector2(219,109)
	bg.size = Vector2(533,277)
	bg.texture = load('res://root/assets/sprites/Menus/back_button.png')
	add_child(bg)
	add_child(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	


	


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://root/multiplayer/multiplayer.tscn")


func _on_back_button_mouse_entered():
	self.color = 'white'
	self.scale = Vector2(1.2,1.2)


func _on_back_button_mouse_exited():
	self.color = 'black'
	self.scale = Vector2(1,1)
