extends "res://scripts/EnemyMotion.gd"

func _ready():
	pass

func enter(_msg := {}) -> void:
	print("Switched to Movement")
	update_path(false)
	owner.path_timer.start()

func process(delta: float) -> void:
	if path.size() > 0 and owner.position.distance_to(path[0]) < 10:
		path.remove(0)
	owner.facing = get_direction()
	owner.myPath.points = path

	if owner.facing.length() == 0:
		state_machine.transition_to("EnemyIdle", { "from": "move"})
		return

	var vel = calculate_velocity()

	owner.move_and_slide(vel)
	set_animation(owner.facing)
	
	if (path.size() > 0):
		return

func exit() -> void:
	pass
	

