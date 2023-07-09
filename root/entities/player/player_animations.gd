# author: Tolib
extends AnimatedSprite2D

var facingLeft = false
var player: CharacterBody2D = null

func _ready():
	# called when entire node tree has loaded
	# for this node
	
	player = get_parent()
	
func _physics_process(delta):
	animate_crabby()

#animates the crabby sprite
func animate_crabby():
	var velocity = player.velocity
	
	if velocity.x > 0:
		facingLeft = false
	if velocity.x < 0:
		facingLeft = true
	if facingLeft:
		if  player.is_on_floor() and velocity.x != 0:
			animation = "run"
		else:
			animation = "idle"
		if velocity.y > 0:
			animation = "jump"
		elif velocity.y < 0:
			animation = "fall"
	else:
		if  player.is_on_floor() and velocity.x != 0:
			animation = "run_right"
		else:
			animation = "idle_right"
		if velocity.y > 0:
			animation = "jump_right"
		elif velocity.y < 0:
			animation = "fall_right"
