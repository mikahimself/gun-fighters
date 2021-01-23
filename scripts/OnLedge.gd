extends "res://scripts/Motion.gd"

func enter(_msg := {}) -> void:
	print("Ledge")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction:
		state_machine.transition_to("Move")
		return
	if not check_ledge():
		state_machine.transition_to("Idle")
		return

func check_ledge() -> bool:
	var rays = owner.rays
	for ray in rays:
		if ray.is_colliding():
			#state_machine.transition_to("OnLedge", { "ray": ray.name} )
			return true
	return false
