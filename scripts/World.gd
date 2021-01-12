extends Node2D

var noise: OpenSimplexNoise
var map_size: Vector2 = Vector2(36, 36)
var sand_cap: float = 0.5
var path_caps: Vector2 = Vector2(0.225, 0.05)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 14
	noise.persistence = 0.8
	draw_maps()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		clear_maps()
		draw_maps()

func clear_maps():
	$Navigation2D/TileMapSand.clear()
	$TileMapPaths.clear()
	$TileMap.clear()

func draw_maps():
	noise.seed = randi()
	create_sand_map()
	create_path_map()
	create_background_map()

func create_sand_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val < sand_cap:
				$Navigation2D/TileMapSand.set_cell(x, y, 0)
	$Navigation2D/TileMapSand.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func create_path_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val > path_caps.y and val < path_caps.x:
				$TileMapPaths.set_cell(x, y, 0)
	$TileMapPaths.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func create_background_map() -> void:
	for x in map_size.x:
		for y in map_size.y:
			if $Navigation2D/TileMapSand.get_cell(x, y) == -1:
				if $Navigation2D/TileMapSand.get_cell(x, y - 1) == 0:
					$TileMap.set_cell(x, y, 0)
	#$TileMap.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func check_edges(x: int, y: int) -> bool:
	return x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y - 1
