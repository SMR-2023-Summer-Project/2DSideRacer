extends Node2D


# Called when the node enters the scene tree for the first time.
var spawn = (Vector2(175,580))
@rpc("call_local")
func _ready():
	#Global.updated_respawn(spawn)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
