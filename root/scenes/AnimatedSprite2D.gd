extends AnimatedSprite2D

func _ready():
	playSpeedBoostAnimation()

var speedBoostAnimation = true

func playSpeedBoostAnimation():
	while speedBoostAnimation:
		self.play("5secspeedboost")
