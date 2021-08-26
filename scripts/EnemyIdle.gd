extends "res://scripts/EnemyMotion.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func enter(_msg := {}) -> void:
	print("Idle")

func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction:
		state_machine.transition_to("Move")
		return
	#if owner.speed > 0.1:
	#	slow_down(delta)
	#	check_ledge()

func exit() -> void:
	pass
