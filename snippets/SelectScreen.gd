####################################################################################
# Author: Iremide J. Akoda                                                         #
# Desc: A script to create buttons for the various level scenes                    #
# Notes: Currently broken/WIP, anyone is free to fix/make changes as it suits them #
####################################################################################
extends Control

const GEAR_BTN = preload("res://GUI/gear_button.tscn")

@export_dir var dir_path

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready() -> void:
	read_dir(dir_path)

func read_dir(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print(file_name)
			create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			print("Found file: " + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
func create_level_btn(lvl_path: String, lvl_name: String) -> void:
	var btn = GEAR_BTN.instantiate()
	btn.text = lvl_name.trim_suffix('.tscn').replace('_', " ")
	btn.level_path = lvl_path
	grid.add_child(btn)
