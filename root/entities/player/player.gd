# author Luc, Tolib
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 800
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0
const CLIMB_SPEED = 100  # Adjust climbing speed as needed


var dashTimer = 0.0
var canDash = true
var hook_pos = Vector2()
var hooked = false
var isClimbing = false
var canDJ = false

@onready var camera = $Camera2D
@onready var rope = $rope
@onready var ray = $RayCast2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if not is_multiplayer_authority(): return
	respawn()
	print("Ready")
	camera.make_current()

	

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	# Add the gravity & Handle double jump
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("jump") and canDJ:
			velocity.y = JUMP_VELOCITY * 0.75
			canDJ = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# Reset double jump condition
		canDJ = true
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
			
#	rope.global_position = self.global_position
#	ray.look_at(get_global_mouse_position())
#
#	if Input.is_action_just_pressed("swing"):
#		if ray.is_colliding():
#			hooked = true
#			print("rope colliding")
#			var colliderobj = ray.get_collider()
#			var colldistance = ray.get_collision_point().distance_to(self.global_position)
#			rope.length = colldistance
#			rope.global_rotation_degrees = ray.global_rotation_degrees - 90
#			rope.rest_length = colldistance * 0.75
#			rope.node_b = colliderobj.get_path()
#			print(rope.node_a)
#			print(rope.node_b)
#
#	if not Input.is_action_pressed("swing"):
#		hooked = false
#		rope.node_b = rope.node_a
	

	# Move and slide.
	#update()
	move_and_slide()
	respawn()


#sets the player back to the most current spawnpoint
func respawn():
	if position.y >= 200:
		position = Global.spawn_point
		
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())






