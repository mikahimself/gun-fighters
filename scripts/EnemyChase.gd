extends "res://scripts/EnemyMotion.gd"


func enter(_msg := {}) -> void:
	print("Chase")
	update_path(false)

func _ready():
	pass # Replace with function body.

func process(delta: float) -> void:
	if path.size() > 0 and owner.position.distance_to(path[0]) < 10:
		path.remove(0)
	owner.facing = get_direction()
	owner.myPath.points = path

	if owner.position.distance_to(owner.player.position) > 50:
		state_machine.transition_to("EnemyMove", { "from": "chase"})
		return

	if owner.facing.length() == 0:
		state_machine.transition_to("EnemyIdle", { "from": "chase"})
		return
	
	var vel = calculate_velocity()

	owner.move_and_slide(vel)
	set_animation(owner.facing)
