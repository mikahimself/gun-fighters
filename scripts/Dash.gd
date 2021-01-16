extends "res://scripts/Motion.gd"

var dashTimer: Timer
var dashCooldownTimer: Timer
var dashTime = 0.25
var dashCooldownTime = 1.0

func enter(_msg := {}) -> void:
	print("Dash")
	setup_dash_timer()
	owner.canDash = false

func setup_dash_timer():
	dashTimer = Timer.new()
	dashTimer.set_one_shot(true)
	dashTimer.set_wait_time(dashTime)
	dashTimer.connect("timeout", self, "_on_dash_timeout")
	add_child(dashTimer)
	dashTimer.start()

func setup_cooldown_timer():
	dashCooldownTimer = Timer.new()
	dashCooldownTimer.set_one_shot(true)
	dashCooldownTimer.set_wait_time(dashTime)
	dashCooldownTimer.connect("timeout", self, "_on_dash_cooldown_timeout")
	add_child(dashCooldownTimer)
	dashCooldownTimer.start()

func process(delta: float) -> void:
	var vel =  owner.facing.normalized() * owner.dash_speed
	owner.move_and_slide(vel)

func _on_dash_timeout():
	print("end dash")
	setup_cooldown_timer()
	state_machine.transition_to("Move")

func _on_dash_cooldown_timeout():
	owner.canDash = true

