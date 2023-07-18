# Author: Habib, Luc

extends Node2D

const STEP_FREQUENCY = 1.0 / 6.0 # max 6 step sounds in 1 second

@onready var jump_sfx = $JumpSfx
@onready var land_sfx = $LandSfx
@onready var step_sfx = $StepSfx
@onready var dash_sfx = $DashSfx
@onready var climb_sfx = $ClimbSfx
@onready var DJ_Sfx = $DJSfx

var player: CharacterBody2D = null

# total duration in seconds since beginning of play
var elapsed_time = 0

# the last time a step sound was played
var last_time_stepped = -INF

# whether or not player was on ground last physics frame
var previously_on_floor = true

var previously_couldDJ = true

var previously_couldDash = true

func _ready():
	# parent of this node will always be assumed
	# to be a characterbody2d being the player
	player = get_parent()

func _physics_process(delta):
	elapsed_time += delta
	
	var player_is_moving_x = player.velocity.x != 0
	var elapsed_since_last_step = elapsed_time - last_time_stepped
	
	if player_is_moving_x and elapsed_since_last_step > STEP_FREQUENCY and player.is_on_floor():
		# player was walking on floor and its time to play step
		step_sfx.play()
		last_time_stepped = elapsed_time
	
	if not player.is_on_floor() and previously_on_floor and player.velocity.y < 0:
		# player has just left the ground going up, jumped?
		print("jump")
		jump_sfx.play()
	elif not player.is_on_floor() and not previously_on_floor and Input.is_action_just_pressed("jump") and previously_couldDJ:
		DJ_Sfx.play()
	elif player.is_on_floor() and not previously_on_floor:
		# player has just landed
		land_sfx.play()
		
	if Input.is_action_just_pressed("dash") and previously_couldDash:
		#player has just pressed dash key
		dash_sfx.play()
		
	if player.get("isClimbing") and (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")) and elapsed_since_last_step > STEP_FREQUENCY:
		# player is in climbing state and moving either up or down
		climb_sfx.play()
		last_time_stepped = elapsed_time
		
	previously_on_floor = player.is_on_floor()
	previously_couldDJ = player.get("canDJ")
	previously_couldDash = player.get("canDash")
	
