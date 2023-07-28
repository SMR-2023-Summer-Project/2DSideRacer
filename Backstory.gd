extends Node2D

var label_node: Label

func _ready():
	label_node = $Panel/Label

func _on_typing_completed():
	get_tree().change_scene_to_file("res://root/scenes/demo_scene/demo_scene.tscn")
