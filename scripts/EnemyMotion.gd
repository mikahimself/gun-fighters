extends State

func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")

func get_input_direction():
	var input_direction = Vector2()
	#input_direction.x = int(Input.is_action_pressed("move_right_%s" % owner.playerID)) - int(Input.is_action_pressed("move_left_%s" % owner.playerID))
	#input_direction.y = int(Input.is_action_pressed("move_down_%s" % owner.playerID)) - int(Input.is_action_pressed("move_up_%s" % owner.playerID))
	return input_direction
