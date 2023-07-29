extends Label

const select = preload('res://root/scenes/Select Map/Map Selector.tscn')
# Called when the node enters the scene tree for the first time.
var selection = null
func _ready():
	$MapButton.pressed.connect( _on_map_button_pressed)
	$MapButton.mouse_entered.connect(_on_map_button_mouse_entered)
	$MapButton.mouse_exited.connect(_on_map_button_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_map_button_pressed():
	if selection != null:
		# If the selection exists, remove it from the button
		selection.queue_free()
		selection = null
	else:
		# If the selection doesn't exist, instantiate and add it to the button
		selection = select.instantiate()
		add_child(selection)
	
func _on_map_button_mouse_entered():
	$MapButton.scale *= 1.5
	$MapButton.position.x -= 22 
	$MapButton.position.y -= 10 


func _on_map_button_mouse_exited():
	$MapButton.scale /= 1.5 
	$MapButton.position.x += 22
	$MapButton.position.y += 10 
