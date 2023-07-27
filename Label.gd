extends Label
var drawTextSpeed: int = 0

func _ready():
	pass
	
func _showChatter():
	#if drawTextSpeed < chatterLimit:
	#	drawTextSpeed += 1
	#	self.visible_characters = drawTextSpeed
	pass
	
func _process(delta):
	_showChatter()
	pass
