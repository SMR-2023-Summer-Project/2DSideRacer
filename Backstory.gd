extends Node2D

var label_node: Label

func _ready():
	label_node = $Panel/Label

func _on_typing_completed():
	get_tree().change_scene_to_file("res://root/multiplayer/multiplayer.tscn")

func _process(delta):
	if Input.is_action_just_pressed("climb"):
		get_tree().change_scene_to_file("res://root/multiplayer/multiplayer.tscn")
	#pass
