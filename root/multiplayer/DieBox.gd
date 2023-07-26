extends Area2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.force_respawn()
func _ready():
	self.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
