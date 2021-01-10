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
	owner.move_and_collide(vel)
	owner.check_borders()
	
func calculate_velocity(delta: float, _input_direction: Vector2) -> Vector2:
	_input_direction = _input_direction.normalized()
	owner.speed = lerp(owner.speed, owner.max_speed, delta * owner.acceleration)
	return owner.speed * delta * _input_direction

func exit():
	pass
