extends "res://scripts/EnemyMotion.gd"

func _ready():
	pass

func enter(_msg := {}) -> void:
	print("Idle")

func process(delta: float) -> void:
	var path = get_path_to_enemy()
	if (path.size() > 0):
		state_machine.transition_to("EnemyMove")
		return

func get_path_to_enemy():
	var path = owner.navigation.get_simple_path(owner.position, Vector2(50, 50))

	if path.size() > 0 and owner.position.distance_to(path[0]) < 10:
		path.remove(0)

	if path.size() > 1 and owner.position.distance_to(path[path.size() - 1]) < 10:
		return []
	else:
		return path

func exit() -> void:
	pass
