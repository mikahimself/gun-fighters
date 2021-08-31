extends State

func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")

func get_input_direction():
	var input_direction = owner.navigation.get_simple_path(Vector2(10, 10), Vector2(200, 200))
	return input_direction
