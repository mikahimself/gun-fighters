extends Node2D

var noise: OpenSimplexNoise
var map_size: Vector2 = Vector2(32, 32)
var sand_cap: float = 0.45
var path_caps: Vector2 = Vector2(0.275, 0.075)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	draw_maps()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		clear_maps()
		draw_maps()

func clear_maps():
	$Navigation2D/TileMapSand.clear()
	$TileMapPaths.clear()

func draw_maps():
	noise.seed = randi()
	create_sand_map()
	create_path_map()

func create_sand_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val < sand_cap or check_edges(x, y):
				$Navigation2D/TileMapSand.set_cell(x, y, 0)
				
	$Navigation2D/TileMapSand.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func create_path_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val > path_caps.y and val < path_caps.x:
				$TileMapPaths.set_cell(x, y, 0)
	$TileMapPaths.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func check_edges(x: int, y: int) -> bool:
	return x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y - 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
