extends State

var path = []
var target_positions = []
var path_attempt_max = 10

func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")

func get_input_direction():
	var input_direction = owner.navigation.get_simple_path(Vector2(10, 10), Vector2(200, 200))
	return input_direction

func update_path(use_alternative_positions):
	if use_alternative_positions:
		var pp = owner.tilemap.world_to_map(owner.player.position)
		var op = owner.tilemap.world_to_map(owner.position)
		var target = get_target_position(pp, op)
		
		path = owner.navigation.get_simple_path(owner.position, target, false)
		var counter = 0
		while path.size() < 1 and counter < path_attempt_max:
			target = get_target_position(pp, op)
			path = owner.navigation.get_simple_path(owner.position, target, false)
			counter += 1
	else:
		path = owner.navigation.get_simple_path(owner.position, owner.player.position, false)
	
	if path.size() > 0 and owner.position.distance_to(path[0]) < 10:
		path.remove(0)

	if path.size() > 1 and owner.position.distance_to(path[path.size() - 1]) < 10:
		path = []

func _on_PathTimer_timeout():
	print("Time to update path")
	if owner.state_machine.state.name == "EnemyMove":
		update_path(true)
		return

func get_target_position(player_pos, own_pos):
	target_positions = [Vector2(5, 5), Vector2(5, -5)] if player_pos.x > own_pos.x else [Vector2(5, 5), Vector2(5, -5)]
	
	var target_m = player_pos + target_positions[randi() % target_positions.size()]
	target_m = clamp_target(target_m)
	var target_w = owner.tilemap.map_to_world(target_m)

	return target_w

func clamp_target(target):
	if target.x > owner.map_size.x:
		target.x = owner.map_size.x - 5
	if target.x < 5:
		target.x = 5
	if target.y > owner.map_size.y:
		target.y = owner.map_size.y - 5
	if target.y < 5:
		target.y = 5
	return target

func calculate_velocity() -> Vector2:
	var dir = owner.facing.normalized()
	owner.speed = lerp(owner.speed, owner.max_speed, owner.acceleration)
	return owner.speed * dir

func get_direction() -> Vector2:
	if (path.size() < 1):
		return Vector2.ZERO
	var x = 0
	var y = 0
	if (path[0].x < owner.position.x and owner.position.x - path[0].x > 3):
		x = -1
	elif (path[0].x > owner.position.x and path[0].x - owner.position.x > 3):
		x = 1
	if (path[0].y < owner.position.y and owner.position.y - path[0].y > 3):
		y = -1
	elif (path[0].y > owner.position.y and path[0].y - owner.position.y > 3):
		y = 1
	return Vector2(x, y)

func set_animation(input_direction: Vector2):
	match input_direction:
		Vector2(0, 1):
			owner.play_animation("Walk_Down")
		Vector2(0, -1):
			owner.play_animation("Walk_Up")
		Vector2(1, 0):
			owner.play_animation("Walk_Right")
		Vector2(1, 1):
			owner.play_animation("Walk_Right")
		Vector2(1, -1):
			owner.play_animation("Walk_Right")
		Vector2(-1, 0):
			owner.play_animation("Walk_Left")
		Vector2(-1, 1):
			owner.play_animation("Walk_Left")
		Vector2(-1, -1):
			owner.play_animation("Walk_Left")
