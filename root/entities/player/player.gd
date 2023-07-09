# author Luc, Tolib
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 800
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0
const CLIMB_SPEED = 100  # Adjust climbing speed as needed
const GRAVITY = 900  # Adjust gravity as needed


var dashTimer = 0.0
var canDash = true
var hook_pos = Vector2()
var hooked = false
var rope_length = 500
var current_rope_length
var isClimbing = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedSprite = $Animations
func _ready():
	current_rope_length = rope_length
	respawn()
	print("Ready")

	

func _physics_process(delta):
	#hook()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle Dash.
	if canDash and dashTimer <= 0.0 and direction != 0:
		if Input.is_action_just_pressed("dash"):
			dashTimer = DASH_DURATION
			canDash = false
			velocity.x = direction * DASH_SPEED

	elif dashTimer > 0.0:
		dashTimer -= delta
		velocity.x = direction * DASH_SPEED

	# Check if dash cooldown is complete.
	if not canDash:
		dashTimer -= delta
		if dashTimer <= 0.0:
			canDash = true
	#Climbing
	if isClimbing:
		if is_on_floor() or not is_on_wall():
			isClimbing = false
		else:
			if Input.is_action_pressed("ui_up"):
				velocity.y = -CLIMB_SPEED
			elif Input.is_action_pressed("ui_down"):
				velocity.y = CLIMB_SPEED
			else:
				velocity.y = 0
	else:
		# Check for climbable walls
		if is_on_wall() and Input.is_action_just_pressed("swing"):
			isClimbing = true
			velocity.y = -CLIMB_SPEED
	
	# Move and slide.
	#hook()
	#update()
	animate_crabby()
	move_and_slide()
	respawn()
func hook():
	$Raycast.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("swing"):
		hook_pos = get_hook_pos()
		if hook_pos:
			hooked = true
			current_rope_length = global_position.distance_to(hook_pos)

func get_hook_pos():
	for raycast in $Raycast.get_children():
		if raycast.is_colliding():
			return raycast.get_collisionn_point()

func animate_crabby():
	if  is_on_floor() and velocity.x != 0:
		animatedSprite.animation = "run"
	else:
		animatedSprite.animation = "idle"
	if velocity.y > 0:
		animatedSprite.animation = "jump"
	elif velocity.y < 0:
		animatedSprite.animation = "fall"



func respawn():
	if position.y >= 200:
		position = Global.spawn_point






