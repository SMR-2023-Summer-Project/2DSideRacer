extends CanvasLayer
const COIN_TEXTURE_PATH = "res://root/assets/sprites/misc/coin.png"
# Called when the node enters the scene tree for the first time.
var coin_count = Label.new()
var coin_sprite: TextureRect
func _ready():
	coin_count.text = str(0)
	#coin_count.scale = Vector2(1, 1)
	coin_count.position = Vector2(70, 20)
	coin_sprite = TextureRect.new()
	coin_sprite.texture = load(COIN_TEXTURE_PATH)
	coin_sprite.scale = Vector2(.05, .05) # Set the size of the coin asset (adjust as needed)
	coin_sprite.position = Vector2(0, 0) # Position the coin in the top-left corner (adjust as needed
	add_child(coin_sprite)
	add_child(coin_count)
	print("UI Started")
