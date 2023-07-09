# author: Tolib
extends Area2D


var x = 0


func _on_body_entered(body: Node) -> void:
	
	if x > 0:
		print(self.position)
		Global.updated_spawn(self.position)
	x += 1
