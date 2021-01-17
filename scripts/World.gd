extends Node2D

var noise: OpenSimplexNoise
var map_size: Vector2 = Vector2(36, 36)
var sand_cap: float = 0.5
var path_caps: Vector2 = Vector2(0.225, 0.05)
onready var player = load("res://scenes/Player.tscn")
var plr

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
	plr.queue_free()

func draw_maps():
	noise.seed = randi()
	create_sand_map()
	create_path_map()
	create_background_map()
	place_player()

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

func place_player() -> void:
	plr = player.instance()
	var foundPosition = false

	for x in range(6, map_size.x / 2+ 6):
		for y in range(6, map_size.y):
			if $Navigation2D/TileMapSand.get_cell(x, y) == 0 and check_surroundings(x, y):
				plr.position = $Navigation2D/TileMapSand.map_to_world(Vector2(x, y)) + Vector2(8, 8)
				foundPosition = true
			if (foundPosition):
				print("placed player at ", plr.position)
				break
		if (foundPosition):
			print("placed player at ", plr.position)
			break
	if (foundPosition):
		add_child(plr)
	else:
		print("Couldnt fin pos")

func check_surroundings(x: int, y:int) -> bool:
	var placeOK = true
	if $Navigation2D/TileMapSand.get_cell(x - 1, y) == -1:
		placeOK = false
	if $Navigation2D/TileMapSand.get_cell(x + 1, y) == -1:
		placeOK = false
	if $Navigation2D/TileMapSand.get_cell(x, y - 1) == -1:
		placeOK = false
	if $Navigation2D/TileMapSand.get_cell(x, y + 1) == -1:
		placeOK = false
	return placeOK
	
	