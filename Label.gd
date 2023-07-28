extends Label

var drawTextSpeed: int = 3  # Adjust this value to control the speed of the typing effect
var chatterLimit: int = 0

func _ready():
	chatterLimit = len(text)  # Set the limit to the length of the text

func _showChatter():
	if visible_characters < chatterLimit:
		visible_characters += drawTextSpeed
	else:
		get_parent().get_parent()._on_typing_completed()

func _process(delta):
	_showChatter()
