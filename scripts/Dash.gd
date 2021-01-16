extends "res://scripts/Motion.gd"

var timer

func enter(_msg := {}) -> void:
	print("Move")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.25)
	timer.connect("timeout", self, "_on_dash_timeout")
	add_child(timer)
	timer.start()

func process(delta: float) -> void:
	var vel =  owner.facing * owner.dash_speed
	owner.move_and_slide(vel)


func _on_dash_timeout():
	print("end dash")
	state_machine.transition_to("Move")


