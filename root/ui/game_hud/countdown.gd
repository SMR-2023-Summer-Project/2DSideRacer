# Author: Habib

extends Label

const MAX_TEXT_SIZE = 400
const GOAL_TEXT_SIZE = 100

const MAX_ROTATION = 180
const GOAL_ROTATION = 0

var is_countdown_playing: bool = false

@onready var horizontal_pane: MarginContainer = null

func start(time: int = 3) -> void:
	# plays the countdown animation on screen
	# starting with the provided number or defaulting to 3
	
	if is_countdown_playing:
		return
	
	is_countdown_playing = true
	
	set_horizontal_pane_scale(Vector2(1, 1))
	
	while time >= 0:
		var time_is_finished = time == 0
		var current_time_str = str(time) if not time_is_finished else "GO!"
		
		# set the text on the timer to current second
		text = current_time_str
		
		# perform the animation on the text
		drop_and_rotate_text(time_is_finished)
		
		# decrement the remaining time
		time -= 1
		
		# pause for one second
		await Global.wait(1)
	
	is_countdown_playing = false
	
	# wait for the final tween to finish
	await set_horizontal_pane_scale(Vector2(1, 0))

func set_horizontal_pane_scale(pane_scale: Vector2) -> Signal:
	# tweens the horizontal line that appears across
	# the countdown digits
	var tween = create_tween()
	
	tween.tween_property(horizontal_pane, "scale", pane_scale, 0.25)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	
	return tween.finished

func drop_and_rotate_text(fade_out: bool) -> Signal:
	# plays an animation where the text falls down and
	# rotation bounces
	
	# reset properties back to defaults before tweening
	theme.default_font_size = MAX_TEXT_SIZE
	rotation_degrees = MAX_ROTATION
	self_modulate = Color(1, 1, 1, 1)
	
	var tween = create_tween()
	
	tween.parallel().tween_property(theme, "default_font_size", GOAL_TEXT_SIZE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "rotation_degrees", GOAL_ROTATION, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	if fade_out:
		tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 1).set_ease(Tween.EASE_OUT)
	
	return tween.finished

func _ready():
	# extract horizontal pane node from parent
	horizontal_pane = get_parent().get_node("HorizontalPane")

func _physics_process(delta):
	pivot_offset = size / 2
