extends Node2D

const Player = preload("res://root/entities/player/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Player.instantiate()
	player.name = str(multiplayer.get_unique_id())
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
