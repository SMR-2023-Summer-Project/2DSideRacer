# author: Tolib
extends Area2D
# Ensures that the function only gets called after a player from the player group goes to a checkpoint
class_name Checkpoint 
# Sets the player spawnpoint to the place of the "checkpoint"
func _on_body_entered(body: Node) -> void:
	if body is Player:
		print(self.position)
		body.update_spawn(self.position)
