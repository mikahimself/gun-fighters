extends "res://scripts/Motion.gd"

func enter(_msg := {}) -> void:
	print("Ledge")
	set_animation(_msg["rays"])
	

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
	var colliding_rays = []
	for ray in rays:
		if ray.is_colliding():
			colliding_rays.append(ray.name)
	if (colliding_rays.size() > 0):
		state_machine.transition_to("OnLedge", { "rays": colliding_rays} )
		return true
	return false

func set_animation(rays) -> void:
	if (owner.facing.x == 1):
		if ("RayRight" in rays):
			owner.play_animation("Ledge-Right")
	if (owner.facing.x == -1):
		if ("RayLeft" in rays):
			owner.play_animation("Ledge-Left")
	if (owner.facing.y == -1):
		if ("RayUp" in rays):
			owner.play_animation("Ledge-Up")
	if (owner.facing.y == 1):
		if ("RayDown" in rays):
			owner.play_animation("Ledge-Down")

	#print (rays)
	# if (ray == "RayUp" && owner.facing.y != 1):
	# 	owner.play_animation("Ledge-Up")
	# if (ray == "RayDown" && owner.facing.y != -1):
	# 	owner.play_animation("Ledge-Down")
	# if (ray == "RayRight"):
		
	# 	owner.play_animation("Ledge-Right")
	# if (ray == "RayLeft"):
	# 	owner.play_animation("Ledge-Left")
