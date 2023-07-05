extends Node2D

@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_scene: PackedScene = load("res://player.tscn")
	var player = player_scene.instantiate()
	
	add_child(player)
	remove_child(camera)
	
	player.add_child(camera)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
