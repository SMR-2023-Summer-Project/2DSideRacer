#Home Screen
#2 Nodes: "Play" button, "Quit" Button


extends Node2D
#When player presses "Quit" everything shuts down
func _on_quit_pressed():
	get_tree().quit()
  
#When player presses "Play" the screen changes to the main screen where the game is
func _on_play_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")
