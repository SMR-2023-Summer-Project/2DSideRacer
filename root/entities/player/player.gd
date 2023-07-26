extends CharacterBody2D
class_name Player

var SPEED = 300.0
var JUMP_VELOCITY = -400.0
var JUMP_POWER_MODIFIER = 4 # Alter degree of jump power increase
const MAX_JUMP_VELOCITY = -600.0 # Limit possible jump power decrease
const WALL_JUMP_VELOCITY = -300.0
const DASH_SPEED = 800
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.35
const CLIMB_SPEED = 100  # Adjust climbing speed as needed
const WALL_JUMP_DELAY = 0.2  # The time window for wall jump after leaving the ground

var speedup = 0
var jumpup = 0
var spawnY = 200
var dash_cool = 0.0
var dashTimer = 0.0
var canDash = true
var hookPos = Vector2()
var hooked = false
var ropeLength = 500
var isClimbing = false
var canDJ = false
var currentRopeLength
var rotating = false
var spawn_point = Global.spawn_point
var powerup_active = false
var powerup_timer = 5
var powerup_type = ""
@onready var camera = $Camera2D
@onready var rope = $rope
@onready var ray = $RayCast2D
#var ui: PackedScene
var coins = 0
var prevDirection = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Wall jump variables
var wallJumpTimer = 0.0

func _ready():
	changeRD()
	force_respawn()
	#ui = preload("res://root/scenes/demo_scene/ui.tscn")
	currentRopeLength = ropeLength
	if not is_multiplayer_authority(): return
	changeRD()
	#respawn()
	print("Ready")
	camera.make_current()
	

func _physics_process(delta):
	#	queue_redraw()
	changeRD()
	#respawn()
	
	if not is_multiplayer_authority(): return
	$Grapple.clear_points()
	# Add the gravity & Handle double jump
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("jump") and canDJ:
			velocity.y = JUMP_VELOCITY * 0.75
			canDJ = false
	wall_jump()
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not Input.is_action_pressed("flip"):
		# Reset double jump condition
		canDJ = true
		velocity.y = JUMP_VELOCITY
	# Handle Jump Power.
	elif !is_on_floor() and Input.is_action_pressed("jump") and velocity.y < 0 and velocity.y > MAX_JUMP_VELOCITY:
		velocity.y -= JUMP_POWER_MODIFIER
	var newDirection = get_direction()
	if newDirection != prevDirection:
		prevDirection = newDirection

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
		dash_cool += delta
		dashTimer -= delta
		if dashTimer <= 0.0 and dash_cool >= DASH_COOLDOWN && is_on_floor():
			canDash = true
			dash_cool = 0

	# Climbing
	if isClimbing:
		if is_on_floor() or not is_on_wall():
			isClimbing = false
		else:
			if Input.is_action_pressed("ui_up"):
				velocity.y = -CLIMB_SPEED
				$PlayerSounds/ClimbSfx.play()
			elif Input.is_action_pressed("ui_down"):
				velocity.y = CLIMB_SPEED
				$PlayerSounds/ClimbSfx.play()
			else:
				velocity.y = 0
	else:
		# Check for climbable walls
		if is_on_wall() and Input.is_action_just_pressed("climb"):
			isClimbing = true
			velocity.y = -CLIMB_SPEED
			$PlayerSounds/ClimbSfx.play()

	# Handle Grapple
	hook()

	if not Input.is_action_pressed("swing"):
		if not Input.is_action_pressed("flip"):
			global_rotation_degrees = 0
		hooked = false
	if hooked:
		global_rotation_degrees = 10 * sin($RayCast2D.global_rotation_degrees)
		swing(delta)
		# Swing speed manipulator
		velocity *= 0.975
		$Grapple.add_point(Vector2(0, 0))
		$Grapple.add_point(to_local(hookPos))

	# Handle grapple cooldown
	if hookCooldownTimer > 0.0:
		hookCooldownTimer -= delta  # Decrease the cooldown timer during each frame

	# Handle Flips
	if Input.is_action_pressed("flip") and not Input.is_action_pressed("swing") and not is_on_floor():
		rotating = true
		global_rotation_degrees = $RayCast2D.global_rotation_degrees
	elif Input.is_action_pressed("flip") and is_on_floor() and rotating:
		global_rotation_degrees = 0
		velocity.y = 10000
		rotating = false
	elif not Input.is_action_pressed("swing"):
		global_rotation_degrees = 0

	# Wall jump logic
	if wallJumpTimer > 0:
		wallJumpTimer -= delta

	# Powerup timing
	if powerup_active:
		if powerup_timer > 0:
			powerup_timer -= delta
		else:
			if speedup == 1:
				SPEED = 300
				powerup_active = false
				speedup -= 1
				print('Speed Boost Ended')
			elif speedup > 1:
				speedup -= 1
			if jumpup == 1:
				JUMP_VELOCITY = -400.0
				JUMP_POWER_MODIFIER = 4
				powerup_active = false
				jumpup -= 1
				print('Jump Boost Ended')
			elif jumpup > 1:
				jumpup -= 1

	move_and_slide()
	

	

const HOOK_COOLDOWN = 0.5 #set the cooldown time
var hookCooldownTimer = 0.0 #initialize timer

func hook():
	if hookCooldownTimer > 0.0: #check if hook is on cooldown
		return
	
	$RayCast2D.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("swing"):
		hookPos = get_hook_pos()
		if hookPos:
			$PlayerSounds/GrappleSfx.play()
			hooked = true
			currentRopeLength = global_position.distance_to(hookPos)
			hookCooldownTimer = HOOK_COOLDOWN #set the hook on cooldown

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
	#$PlayerSounds/SwingSfx.play()
	velocity += (hookPos - global_position).normalized() * 15000 * delta

# sets the player back to the most current spawnpoint
func respawn():
	if position.y >= spawnY:
		$PlayerSounds/HurtSfx.play()
		position = spawn_point
		print(position)
		
func force_respawn():
	position = spawn_point
	$PlayerSounds/HurtSfx.play()
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func update_spawn(new_position):
	spawn_point = new_position

func addCoins():
	coins += 1
	print("This player added a coin, coin count is: ", coins)
	$UI/GameHUD.get_node('CoinCount').text = str(coins)+" / 5"
	$PlayerSounds/CoinCollectSfx.play()

# Function to handle wall jumps
func changeRD():
	spawnY = Global.spawnY
func wall_jump():
	if is_on_wall() and wallJumpTimer <= 0.0:
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			if get_direction() != prevDirection && Input.is_action_pressed("ui_up"):
				print('wall jump')
				velocity.y = WALL_JUMP_VELOCITY * 1.5
				wallJumpTimer = WALL_JUMP_DELAY
func get_direction():
	# Get the input direction and return 0 if no direction, -1 if left, and 1 if right
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		return -1
	elif direction > 0:
		return 1
	return 0

func fiveSecondSpeedUp():
	powerup_active = true
	powerup_timer = 5
	powerup_type = 'speedboost'
	speedup += 1 
	$PlayerSounds/PowerUpSfx.play()
	print("The player has collected a five second speed boost.")
	if speedup == 1:
		SPEED = 550.0
	else:
		print('Speed Power Up extended by: ', powerup_timer, ' seconds.')
	
func fiveSecondJumpBoost():
	powerup_active = true
	powerup_timer = 5
	powerup_type = 'jumpboost'
	jumpup += 1 
	$PlayerSounds/PowerUpSfx.play()
	print("The player has collected a five second jump boost.")
	if jumpup == 1:
		JUMP_VELOCITY = -600.0
		JUMP_POWER_MODIFIER = 8
	else:
		print('Jump Power Up extended by: ', powerup_timer, ' seconds.')
	
