extends Node2D


# Called when the node enters the scene tree for the first time.

var back_button : BackButton
var stage_Selection = []


func _ready():
	self.scale *= 1.6
	self.position.y -= 300
	stage_Selection.append( StageButton.new())
	stage_Selection[0] = StageButton.new()
	back_button = BackButton.new()
	back_button.closeScene = true
	back_button.previousScene = "res://root/multiplayer/multiplayer.tscn"
	stage_Selection[0].imgFile = 'res://root/assets/sprites/Selection Icons/Industrial Image.png'
	stage_Selection[0].Scene = 'res://root/multiplayer/multiplayer.tscn'
	add_child(stage_Selection[0])
	add_child(back_button)
	stage_Selection[0].position = Vector2(300,200)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
