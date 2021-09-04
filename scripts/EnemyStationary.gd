extends "res://scripts/EnemyMotion.gd"

var BREAK_DISTANCE = 75

func enter(_msg := {}) -> void:
	print("Stationary")

func process(delta: float) -> void:
	update_path(true)
	if owner.position.distance_to(owner.player.position) > BREAK_DISTANCE:
		update_path(true)
		state_machine.transition_to("EnemyMove")
		return

func _on_IdleTimer_timeout():
	update_path(true)
	print("Idle timer out")
	state_machine.transition_to("EnemyMove")
	pass