extends "res://scripts/Motion.gd"

func enter(_msg := {}) -> void:
	print("Move")

func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction.length() == 0:
		state_machine.transition_to("Idle")
		return
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
	if input_direction.y == 1 and input_direction.x == 0:
		owner.play_animation("Walk_Down")
	if input_direction.y == -1 and input_direction.x == 0:
		owner.play_animation("Walk_Up")
	if input_direction.x == 1:
		owner.play_animation("Walk_Right")
	if input_direction.x == -1:
		owner.play_animation("Walk_Left")