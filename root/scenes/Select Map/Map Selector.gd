# Author: idk
# extended on by hasan

extends Node2D


# Called when the node enters the scene tree for the first time.

var back_button : BackButton
var stage_Selection = []


func _ready():
	
	# map selector positioning
	self.scale *= 1
	self.position.y -= 325
	self.position.x -= 10
	
	
	# back button
	back_button = BackButton.new()
	back_button.closeScene = true
	back_button.previousScene = "res://root/multiplayer/multiplayer.tscn"
	add_child(back_button)
	
	#map 1
	stage_Selection.append( StageButton.new())
	stage_Selection[0].imgFile = 'res://root/assets/sprites/Selection Icons/lobby.png'
	stage_Selection[0].Scene = 'res://root/scenes/demo_scene_2/demo_scene_2.tscn'
	stage_Selection[0].position = Vector2(250,200)
	stage_Selection[0].scale = Vector2(0.9, 0.9)
	add_child(stage_Selection[0])
	stage_Selection[0].queue_free()
	
	#map 2
	stage_Selection.append(StageButton.new())
	stage_Selection[1].imgFile = 'res://root/assets/sprites/Selection Icons/random.png'
	stage_Selection[1].Scene = 'res://root/scenes/maps/Random_Map/random_map.tscn'
	stage_Selection[1].position = Vector2(250,200)
	stage_Selection[1].scale = Vector2(0.9, 0.9)
	add_child(stage_Selection[1])
	
	#map 3
	stage_Selection.append( StageButton.new())
	stage_Selection[2].imgFile="res://root/assets/sprites/Selection Icons/sky city.jpg"
	stage_Selection[2].Scene="res://SkyCity.tscn"
	stage_Selection[2].position= Vector2(500,200)
	stage_Selection[2].scale = Vector2(0.9, 0.9)
	add_child(stage_Selection[2])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
