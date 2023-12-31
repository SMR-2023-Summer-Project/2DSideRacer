extends ColorRect
class_name StageButton
var image : TextureRect

var button : TextureButton
#var bgOffset = position - Vector2(-159,-79) 
@export var imgFile = ''
var butOffset = Vector2(-36,-20) 
@export var Scene = ''
#export(String) var Scene
func _ready():
	color = 'black'
	button = TextureButton.new()
	image = TextureRect.new()
	size = Vector2(240,135)
	
	#button.position = position + butOffset
	
	#size = Vector2(225,115)
	#scale = Vector2(.75,.75)
	button.size = size
	image.scale = Vector2(.9,.9)
	image.position += Vector2(11,6)
	image.texture = load(imgFile)
	add_child(image)
	add_child(button)
	button.pressed.connect(_on_stage_button_pressed)
	button.mouse_entered.connect(_on_stage_button_mouse_entered)
	button.mouse_exited.connect(_on_stage_button_mouse_exited)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	


	


func _on_stage_button_pressed():
	if Global.players > 0:
		Global.change_mapChose(true, Scene)
		print('Stage Selected')
	else:
		Global.display_player_message('Not enough players to start, this requires 2 or more.')
	#get_tree().change_scene_to_file(Scene)
	get_parent().queue_free()
	


func _on_stage_button_mouse_entered():
	self.color = 'white'
	self.scale = Vector2(1.2,1.2)


func _on_stage_button_mouse_exited():
	self.color = 'black'
	self.scale = Vector2(1,1)
