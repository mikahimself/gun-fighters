extends "res://scripts/Motion.gd"

func enter(_msg := {}) -> void:
	print("Ledge. Rays: ", _msg["edges"].size())
	set_animation(_msg["edges"])
	

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction:
		state_machine.transition_to("Move")
		return

func set_animation(edges) -> void:
	
	for edge in edges:
		if edge == 0:
			owner.play_animation("Ledge-Left")
		elif edge == 1:
			owner.play_animation("Ledge-Right")
		elif edge == 2:
			owner.play_animation("Ledge-Up")
		elif edge == 3:
			owner.play_animation("Ledge-Down")
