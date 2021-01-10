extends KinematicBody2D

var myVelocity = Vector2.ZERO
var max_speed = 100
var speed = 0
var facing := Vector2(1, 0)
var acceleration = 1
onready var state_label = $StateLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.connect("transitioned", self, "on_state_transitioned")

func on_state_transitioned(state: String):
	state_label.set_text(state)

func check_borders() -> void:
	if position.x < 8:
		position.x = 8
	if position.x > 472:
		position.x = 472
	if position.y > 312:
		position.y = 312
	if position.y < 8:
		position.y = 8
