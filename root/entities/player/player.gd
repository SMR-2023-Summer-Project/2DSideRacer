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
var hookPos = Vector2()
var hooked = false
var ropeLength = 500
var isClimbing = false
var canDJ = false
var currentRopeLength

@onready var camera = $Camera2D
@onready var rope = $rope
@onready var ray = $RayCast2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	currentRopeLength = ropeLength
	if not is_multiplayer_authority(): return
	respawn()
	print("Ready")
	camera.make_current()

func _physics_process(delta):
	#print(velocity)
#	queue_redraw()
	if not is_multiplayer_authority(): return
	$Line2D.clear_points()
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
		if is_on_wall() and Input.is_action_just_pressed("climb"):
			isClimbing = true
			velocity.y = -CLIMB_SPEED
			
	hook()
	
	if not Input.is_action_pressed("swing"):
		hooked = false
	if hooked:
		
		swing(delta)
		# Swing speed manipulator
		self.velocity *= 0.975
		$Line2D.add_point(Vector2(0, 0))
		$Line2D.add_point(to_local(hookPos))
	move_and_slide()
	respawn()
	
func hook():
	$RayCast2D.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("swing"):
		hookPos = get_hook_pos()
		if hookPos:
			hooked = true
			currentRopeLength = global_position.distance_to(hookPos)
		
func get_hook_pos():
	if $RayCast2D.is_colliding():
		return $RayCast2D.get_collision_point()
		
func swing(delta):
	var radius = global_position - hookPos
	if velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(velocity) / (radius.length() * velocity.length()))
	var radVel = cos(angle) * velocity.length()
	velocity += radius.normalized() * -radVel
	
	if global_position.distance_to(hookPos) > currentRopeLength:
		global_position = hookPos + radius.normalized() * currentRopeLength
		
	velocity += (hookPos - global_position).normalized() * 15000 *delta
	
#func _draw():
#	var pos = global_position
#	if hooked:
#		draw_line(Vector2(0, 0), to_local(hookPos), Color(1.0, 0.5, 0.0), 3, true)
#	else:
#		return
	

#sets the player back to the most current spawnpoint
func respawn():
	if position.y >= 200:
		position = Global.spawn_point
		
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())






