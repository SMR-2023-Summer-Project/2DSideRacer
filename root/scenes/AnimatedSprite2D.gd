extends AnimatedSprite2D

func _ready():
	playSpeedBoostAnimation()

var speedBoostAnimation = true

func playSpeedBoostAnimation():
	self.play("5secspeedboost")
