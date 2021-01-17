extends "res://scripts/State.gd"

var dieTimer

func enter(_msg := {}) -> void:
	print("Fall")
	owner.play_animation("Fall")
	setup_dash_timer()

func setup_dash_timer():
	dieTimer = Timer.new()
	dieTimer.set_one_shot(true)
	dieTimer.set_wait_time(2.0)
	dieTimer.connect("timeout", self, "_on_fall_timeout")
	add_child(dieTimer)
	dieTimer.start()

func _on_fall_timeout():
	state_machine.transition_to("Idle")
	print("fall timeout")
	owner.speed = 0
	owner.position = owner.initial_position
