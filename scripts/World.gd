extends Node2D

var noise: OpenSimplexNoise
var map_size: Vector2 = Vector2(34, 24)
var sand_cap: float = 0.5
var path_attempt_max: int = 32
var path_caps: Vector2 = Vector2(0.225, 0.05)
onready var nav2d = $Navigation2D
onready var sand_map = $Navigation2D/TileMapSand
onready var path_map = $Navigation2D/TileMapPaths
onready var prop_map = $Navigation2D/TileMapProps
onready var player = load("res://scenes/Player.tscn")
onready var cactus = load("res://scenes/Cactus.tscn")
var plr
signal basemap_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	connect("basemap_finished", self, "on_base_finished")
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 14
	noise.persistence = 0.8
	draw_maps()

func on_base_finished():
	create_path_map()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		clear_maps()
		draw_maps()
	if event.is_action_pressed("draw_roads"):
		create_path_map()
		#$Navigation2D/TileMapPaths.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func clear_maps():
	sand_map.clear()
	path_map.clear()
	prop_map.clear()
	$TileMap.clear()
	plr.queue_free()
	for child in $YSort.get_children():
		child.queue_free()

func draw_maps():
	noise.seed = randi()
	create_sand_map()
	create_background_map()
	place_player()
	place_props()

func place_props():
	for x in map_size.x:
		for y in map_size.y:
			if sand_map.get_cell_autotile_coord(x, y) == Vector2(7, 5):
				place_cactus(sand_map.map_to_world(Vector2(x, y)))

func create_sand_map(): 
	for x in map_size.x:
		for y in map_size.y:
			var val = noise.get_noise_2d(x, y)
			if val < sand_cap:
				sand_map.set_cell(x, y, 0)
	update_bitmask(sand_map)
	yield(get_tree().create_timer(0.015), "timeout")
	emit_signal("basemap_finished")

func create_path_points(isVertical: bool) -> PoolVector2Array:
	var counter = 0
	var path: PoolVector2Array = []
	var start = create_path_point(isVertical, false)
	var end = create_path_point(isVertical, true)
	path = nav2d.get_simple_path(start, end, false)

	while path.size() < 20 && counter < path_attempt_max:
		start = create_path_point(isVertical, false)
		end = create_path_point(isVertical, true)
		path = nav2d.get_simple_path(start, end, false)
		counter = counter + 1
	return path

func create_path_point(is_vertical_path: bool, is_end_point: bool):
	var counter = 0
	var start_y
	var start_x

	if is_vertical_path:
		start_y = 0.0 if is_end_point else map_size.y
		start_x = randi() % int(map_size.x - 1)
		while (sand_map.get_cell(start_x, 0) != 0 and counter < 32):
			start_x = randi() % int(map_size.x - 1)
			counter = counter + 1
	else:
		start_x = map_size.x - 1 if is_end_point else 0.0
		start_y = randi() % int(map_size.y - 1)
		while(sand_map.get_cell(0, start_y) != 0 and counter < 32):
			start_y = randi() % int(map_size.y - 1)
			counter = counter + 1
	return path_map.map_to_world(Vector2(start_x, start_y))

func create_path_map():
	var h_path = create_path_points(false)
	var v_path = create_path_points(true)
	place_path_points(h_path)
	place_path_points(v_path)
	update_bitmask(path_map)

func place_path_points(path: PoolVector2Array):
	for i in path.size():
		if i > 0:
			var prev = path_map.world_to_map(path[i - 1])
			var curr = path_map.world_to_map(path[i])

			if curr.x > prev.x && curr.y < prev.y:
				path_map.set_cell(curr.x - 1, curr.y, 0)
			elif curr.x > prev.x && curr.y > prev.y:
				path_map.set_cell(curr.x, curr.y - 1, 0)
			path_map.set_cell(curr.x, curr.y, 0)

func update_bitmask(map: TileMap) -> void:
	map.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))


func create_background_map() -> void:
	for x in map_size.x:
		for y in map_size.y:
			if sand_map.get_cell(x, y) == -1:
				if sand_map.get_cell(x, y - 1) == 0:
					$TileMap.set_cell(x, y, 0)
	#$TileMap.update_bitmask_region(Vector2.ZERO, Vector2(map_size.x, map_size.y))

func check_edges(x: int, y: int) -> bool:
	return x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y - 1

func place_cactus(place_position: Vector2) -> void:
	var c = cactus.instance()
	c.position = place_position
	$YSort.add_child(c)

func place_player() -> void:
	plr = player.instance()
	var foundPosition = false

	for x in range(6, map_size.x / 2+ 6):
		for y in range(6, map_size.y):
			if sand_map.get_cell(x, y) == 0 and check_surroundings(x, y):
				plr.position = sand_map.map_to_world(Vector2(x, y))
				foundPosition = true
			if (foundPosition):
				print("placed player at ", plr.position)
				break
		if (foundPosition):
			print("placed player at ", plr.position)
			break
	if (foundPosition):
		$YSort.add_child(plr)
	else:
		print("Couldnt fin pos")

func check_surroundings(x: int, y:int) -> bool:
	var placeOK = true
	if sand_map.get_cell(x - 1, y) == -1:
		placeOK = false
	if sand_map.get_cell(x + 1, y) == -1:
		placeOK = false
	if sand_map.get_cell(x, y - 1) == -1:
		placeOK = false
	if sand_map.get_cell(x, y + 1) == -1:
		placeOK = false
	return placeOK
