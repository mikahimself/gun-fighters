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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
