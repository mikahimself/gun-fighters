extends State

var path = []
var target_positions = [
	Vector2(10, 0),
	Vector2(-10, 0),
	Vector2(0, 10),
	Vector2(0, -10),
]

func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")

func get_input_direction():
	var input_direction = owner.navigation.get_simple_path(Vector2(10, 10), Vector2(200, 200))
	return input_direction

func update_path(use_alternative_positions):
	if use_alternative_positions:
		var gp = owner.tilemap.world_to_map(owner.player.position)
		var target = get_target_position(gp)
		
		path = owner.navigation.get_simple_path(owner.position, target, false)
		while path.size() < 1:
			target = get_target_position(gp)
			path = owner.navigation.get_simple_path(owner.position, target, false)
	else:
		path = owner.navigation.get_simple_path(owner.position, owner.player.position, false)
	
	if path.size() > 0 and owner.position.distance_to(path[0]) < 10:
		path.remove(0)

	if path.size() > 1 and owner.position.distance_to(path[path.size() - 1]) < 10:
		print("path trimmed to nothing")
		path = []

func _on_PathTimer_timeout():
	print("Time to update path")
	if owner.state_machine.state.name == "EnemyMove":
		path = owner.navigation.get_simple_path(owner.position, owner.player.position, false)

func get_target_position(player_pos):
	var target_m = player_pos + target_positions[randi() % target_positions.size()]
	target_m = clamp_target(target_m)
	var target_w = owner.tilemap.map_to_world(target_m)
	return target_w

func clamp_target(target):
	if target.x > owner.map_size.x:
		target.x = owner.map_size.x - 3
	if target.x < 3:
		target.x = 3
	if target.y > owner.map_size.y:
		target.y = owner.map_size.y - 3
	if target.y < 3:
		target.y = 3
	return target