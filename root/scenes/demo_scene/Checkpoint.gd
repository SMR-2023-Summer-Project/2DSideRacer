# author: Tolib
extends Area2D
# Sets the player spawnpoint to the place of the "checkpoint"
#Makes this into a new node
class_name Checkpoint 
#makes the collision box
var collisionShape = CollisionShape2D.new()
#detects player
func _on_body_entered(body: Node) -> void:
	if body is Player:
		print(self.position)#prints the position of the checkpoint
		body.update_spawn(self.position)#updates the players spawnpoint
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)#makes the detection work
	#makes the shape of the box, the size of it, and makes it a child of the checkpoint
	collisionShape.shape = RectangleShape2D.new()
	collisionShape.shape.extents = Vector2(20, 50)
	add_child(collisionShape)

