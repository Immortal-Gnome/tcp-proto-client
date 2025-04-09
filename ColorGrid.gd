extends GridContainer
class_name ColorGrid

var tiles := []

@export var width = 5
@export var height = 5

@onready var tile : PackedScene = preload("res://scenes/tile.tscn")


func _ready() -> void:
	tiles = []
	tiles.resize(width)
	for x in range(width):
		tiles[x] = Array()
		tiles[x].resize(width)
		for y in range(height):
			var _tile = tile.instantiate() as TextureRect
			tiles[x][y] = _tile
			add_child(_tile)
			if x == 0 and y == 0:
				_tile.modulate = Color.RED
			elif x == width - 1 and y == 0:
				_tile.modulate = Color.YELLOW
			elif x == width - 1 and y == height - 1:
				_tile.modulate = Color.GREEN
	

func _set_all_random() -> void:
	for x in range(width):
		for y in range(height):
			var c : Color
			c.r = randf()
			c.g = randf()
			c.b = randf()
			_set_tile(x,y,c)


func _set_all_white() -> void:
	for x in range(width):
		for y in range(height):
			var c : Color
			c.r = 1.0
			c.g = 1.0
			c.b = 1.0
			_set_tile(x,y,c)


func _set_tile(x,y : int, c : Color) -> void:
	tiles[x][y].modulate = c
