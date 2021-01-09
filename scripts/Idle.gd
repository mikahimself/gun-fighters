extends "res://scripts/Motion.gd"

var slow_down = 0.25
var slow_down_elapsed = 0

func enter(_msg := {}) -> void:
	print("Idle")			

func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction:
		state_machine.transition_to("Move")
	if owner.speed > 0.1:
		slow_down(delta)
	

func slow_down(delta) -> void:
	if slow_down_elapsed < slow_down:
		slow_down_elapsed += delta
		owner.speed = lerp(50, 0, slow_down_elapsed / slow_down * 2)
		var vel = owner.speed * delta * owner.facing.normalized()
		owner.move_and_collide(vel)
	if owner.speed <= 0.15:
		owner.speed = 0
		slow_down_elapsed = 0

func exit() -> void:
	pass
