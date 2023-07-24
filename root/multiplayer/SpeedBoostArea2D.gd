extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.fiveSecondSpeedUp()
		get_parent().queue_free()
