extends Node2D

var noise: OpenSimplexNoise
var map_size: Vector2 = Vector2(34, 24)
var sand_cap: float = 0.5
var path_caps: Vector2 = Vector2(0.225, 0.05)
onready var path_map = $Navigation2D/TileMapPaths
onready var sand_map = $Navigation2D/TileMapSand
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
	if event.is_action_pressed("draw_roads"):
		create_navpath_map()
		#$Navigation2D/TileMapPaths.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func clear_maps():
	$Navigation2D/TileMapSand.clear()
	$Navigation2D/TileMapPaths.clear()
	$TileMap.clear()
	plr.queue_free()

func draw_maps():
	noise.seed = randi()
	create_sand_map()
	#create_path_map()
	create_background_map()
	place_player()

func create_sand_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val < sand_cap:
				$Navigation2D/TileMapSand.set_cell(x, y, 0)
	$Navigation2D/TileMapSand.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func create_horizontal_path():
	print("Create map")
	var counter = 0
	var start = path_map.map_to_world(create_start_point(false))
	var end = path_map.map_to_world(create_end_point(false))
	var path = $Navigation2D.get_simple_path(start, end, false)
	print ("Start: ", start, " END: ", end)
	while path.size() < 20 && counter < 20:
		start = path_map.map_to_world(create_start_point(false))
		end = path_map.map_to_world(create_end_point(false))
		path = $Navigation2D.get_simple_path(start, end, false)
		counter = counter + 1
	
	return path

func create_vertical_path():
	#var start = path_map.map_to_world(Vector2(rand_range(4, map_size.x - 4), 32))
	
	var start = create_start_point(true)
	var end = path_map.map_to_world(Vector2(rand_range(4, map_size.x - 4), 0))
	var path = $Navigation2D.get_simple_path(start, end, false)
	if path.size() < 5:
		create_vertical_path()
	return path

func create_start_point(isVertical: bool):
	var counter = 0
	var start_y = 0
	var start_x = 0
	if isVertical:
		start_x = randi() % int(map_size.x - 1)
		while (sand_map.get_cell(start_x, 0) != 0 and counter < 32):
			start_x = randi() % int(map_size.x - 1)
			counter = counter + 1
	else:
		start_y = randi() % int(map_size.y - 1)
		while(sand_map.get_cell(0, start_y) != 0 and counter < 32):
			start_y = randi() % int(map_size.y - 1)
			counter = counter + 1
	return Vector2(start_x, start_y)

func create_end_point(isVertical: bool):
	var counter = 0
	var start_y = 0
	var start_x = 0
	if isVertical:
		start_y = map_size.y - 1
		start_x = randi() % int(map_size.x - 1)
		print(sand_map.get_cell(start_x, map_size.y))
		while (sand_map.get_cell(start_x, map_size.y) != 0 and counter < 32):
			start_x = randi() % int(map_size.x - 1)
			counter = counter + 1
	else:
		start_x = map_size.x - 1
		start_y = randi() % int(map_size.y - 1)
		while(sand_map.get_cell(map_size.x, start_y) != 0 and counter < 32):
			start_y = randi() % int(map_size.y - 1)
			counter = counter + 1
	return Vector2(start_x, start_y)
		


func create_path_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val > path_caps.y and val < path_caps.x:
				$Navigation2D/TileMapPaths.set_cell(x, y, 0)
	#$TileMapPaths.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func create_navpath_map():
	#var path = $Navigation2D.get_simple_path(Vector2(32, 32), Vector2(400, 360), false)
	var path = create_horizontal_path()
	#$Line2D.points = path
	#var path2 = create_vertical_path()
	#$Line2D.points = path;
	for x in path.size():
		if x > 0:
			var prev = path_map.world_to_map(path[x - 1])
			var curr = path_map.world_to_map(path[x])
			# 
			if curr.x > prev.x && curr.y < prev.y:
				path_map.set_cell(curr.x - 1, curr.y, 0)
			elif curr.x > prev.x && curr.y > prev.y:
				path_map.set_cell(curr.x, curr.y - 1, 0)
			path_map.set_cell(curr.x, curr.y, 0)

	# for x in path2.size():
	# 	if x > 0:
	# 		var prev = path_map.world_to_map(path2[x - 1])
	# 		var curr = path_map.world_to_map(path2[x])
	# 		# 
	# 		if curr.x > prev.x && curr.y < prev.y:
	# 			path_map.set_cell(curr.x - 1, curr.y, 0)
	# 		elif curr.x > prev.x && curr.y > prev.y:
	# 			path_map.set_cell(curr.x, curr.y - 1, 0)
	# 		path_map.set_cell(curr.x, curr.y, 0)

	$Navigation2D/TileMapPaths.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))



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
				plr.position = $Navigation2D/TileMapSand.map_to_world(Vector2(x, y))
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
	
	
