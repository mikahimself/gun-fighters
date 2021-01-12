extends "res://scripts/Motion.gd"

var slow_down_time = 0.25
var slow_down_elapsed = 0

func enter(_msg := {}) -> void:
	print("Idle")
	print(owner.facing)
	if (owner.facing.y == -1):
		owner.play_animation("Idle_Up")
	else:
		owner.play_animation("Idle_Down")

func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction:
		state_machine.transition_to("Move")
		return
	if owner.speed > 0.1:
		slow_down(delta)
	check_ledge()

func check_ledge() -> void:
	var rays = owner.rays
	for ray in rays:
		if ray.is_colliding():
			state_machine.transition_to("OnLedge", { "ray": ray.name} )

func slow_down(delta) -> void:
	if slow_down_elapsed < slow_down_time:
		slow_down_elapsed += delta
		owner.speed = lerp(50, 0, slow_down_elapsed / slow_down_time * 2)
		var vel = owner.speed * delta * owner.facing.normalized()
		owner.move_and_collide(vel)
		owner.check_borders()
	if owner.speed <= 0.15:
		owner.speed = 0
		slow_down_elapsed = 0

func exit() -> void:
	pass
