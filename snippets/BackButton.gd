####################################################################################
# Author: Iremide J. Akoda                                                         #
# Desc: A script to grow buttons when hovered over/taken off of and change scenes  #
# Notes: Currently broken/WIP, anyone is free to fix/make changes as it suits them #
####################################################################################
extends Button

@export_file var level_path
var original_size = scale
var grow_size = Vector2(1.1, 1.1)


func _on_LvlBtn_mouse_entered() -> void:
	grow_size_tween(grow_size, .1)


func _on_LvlBtn_mouse_exited() -> void:
	grow_size_tween(original_size, .1)
	
	
func grow_size_tween(end_size: Vector2, duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', end_size, duration)


func _on_LvlBtn_pressed() -> void:
	if level_path == null:
		return
	get_tree().change_scene(level_path)
