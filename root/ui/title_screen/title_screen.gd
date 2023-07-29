# author: Haley Patel
#Home Screen
extends Control

#2 Nodes: "Play" button, "Quit" Button

#When player presses "Quit" everything shuts down
func _on_quit_pressed():
	get_tree().quit()
  
#When player presses "Play" the screen changes to the main screen where the game is
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Backstory.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://root/scenes/Credits/credits_1.tscn")
