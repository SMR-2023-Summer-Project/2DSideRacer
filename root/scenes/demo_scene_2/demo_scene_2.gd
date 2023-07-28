extends Node2D


const Player = preload("res://root/entities/player/player.tscn")
# Called when the node enters the scene tree for the first time.

# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.updated_respawn_distance(position + Vector2(-200,-200))
	Global.updated_respawn(Vector2(71,218))
	#position = Vector2(0,0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
