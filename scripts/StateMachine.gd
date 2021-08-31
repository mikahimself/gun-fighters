class_name StateMachine
extends Node

signal transitioned(state_name)

export var initial_state: NodePath
onready var state: State = get_node(initial_state)


func _ready():
	#yield(owner, ready)
	for child in get_children():
		child.state_machine = self
		state.enter()
		emit_signal("transitioned", state.name)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.process(delta)

func _physics_process(delta: float) -> void:
	state.physics_process(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		print("no target state ", state.name)
		return

	state.exit()
	state = get_node(target_state_name)
	emit_signal("transitioned", state.name)
	state.enter(msg)
