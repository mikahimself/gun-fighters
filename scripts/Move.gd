extends "res://scripts/Motion.gd"

func enter(_msg := {}) -> void:
	print("Move")

func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction.length() == 0:
		state_machine.transition_to("Idle")
		return
	if Input.is_action_pressed("move_dash"):
		state_machine.transition_to("Dash");
	owner.facing = input_direction
	var vel = calculate_velocity(delta, input_direction)
	owner.move_and_slide(vel)
	for i in owner.get_slide_count():
		var collision = owner.get_slide_collision(i)
	set_animation(input_direction)
	owner.check_borders()
	
func calculate_velocity(delta: float, _input_direction: Vector2) -> Vector2:
	_input_direction = _input_direction.normalized()
	owner.speed = lerp(owner.speed, owner.max_speed, owner.acceleration)
	return owner.speed * _input_direction

func exit():
	pass

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
