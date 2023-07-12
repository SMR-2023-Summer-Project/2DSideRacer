# author: Tolib
extends Area2D

#ensures that the function only gets called after a player goes to a checkpoint
var x = 0

#sets the player spawnpoint to the place of the "checkpoint"
func _on_body_entered(body: Node) -> void:
	
	if x > 0:
		print(self.position)#prints current position
		Global.updated_spawn(self.position)
	x += 1
