extends Area2D
#Makes this into a new node
class_name Coin

#makes the collision box
var collisionShape = CollisionShape2D.new()
# makes the sprite node
var spriteNode = Sprite2D.new()

		
func _ready() -> void:
	collisionShape.shape = RectangleShape2D.new()
	collisionShape.shape.extents = Vector2(20, 50)
	add_child(collisionShape)
	# adds texture + scale to coin
	spriteNode.texture = load('res://root/assets/sprites/misc/coin.png')
	spriteNode.scale = Vector2(0.025, 0.025)
	add_child(spriteNode)
