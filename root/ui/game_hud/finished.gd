# Author: Habib
extends Label

var flags_top: Control = null
var flags_bottom: Control = null

func appear():
	# causes the checkered flags to scroll into view and
	# the label to slide across the screen
	
	var window_size = get_window().size
	
	# set off screen initially so it can scroll on
	position = Vector2(window_size.x, 0)
	theme.default_font_size = 100
	modulate = Color(1, 1, 1, 1)
	
	var tween = create_tween()
	
	# slide the text on screen
	tween.tween_property(self, "position", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()
	
	# show the two banners
	tween.tween_property(flags_top, "anchor_top", 0.477, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()
	
	tween.tween_property(flags_bottom, "anchor_top", 0.788, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()
	
		
	await tween.finished

func disappear():
	# causes the flags to retract off screen and
	# the label to fade out
	
	var window_size = get_window().size
	var tween = create_tween()
	
	# make font big and fade out
	tween.tween_property(theme, "default_font_size", 200, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()
	
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()
	
	# hide the two banners
	tween.tween_property(flags_top, "anchor_top", 0.0, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()
	
	tween.tween_property(flags_bottom, "anchor_top", 1.5, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel()

	await tween.finished

func _ready():
	# retrieve the flag objects from parent
	var parent = get_parent()
	
	flags_top = parent.get_node("CheckeredFlagTop")
	flags_bottom = parent.get_node("CheckeredFlagBottom")
