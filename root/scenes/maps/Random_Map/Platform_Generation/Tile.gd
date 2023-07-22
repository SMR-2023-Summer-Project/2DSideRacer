extends CharacterBody2D

var tile_width

func _ready():
	tile_width = $Sprite2D.texture.get_size().x * scale.x
	
