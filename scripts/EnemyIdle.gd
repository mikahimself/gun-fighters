extends "res://scripts/EnemyMotion.gd"

var can_move = false
var idle_timer

func _ready():
	idle_timer = Timer.new()
	idle_timer.connect("timeout", self, "_on_IdleTimer_timeout")
	idle_timer.one_shot = true
	idle_timer.wait_time = 0.5
	add_child(idle_timer)

func enter(_msg := {}) -> void:
	print("Enter enemy Idle")
	idle_timer.start()
	

func process(delta: float) -> void:
	if (can_move):
		update_path(true)
		if (path.size() > 0):
			state_machine.transition_to("EnemyMove", {"from": "idle"})
			can_move = false
			return

func exit() -> void:
	pass

func _on_IdleTimer_timeout():
	can_move = true
	print("Idle timer out")
