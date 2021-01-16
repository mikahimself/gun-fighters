extends KinematicBody2D

var myVelocity = Vector2.ZERO
var max_speed = 35
var dash_speed = 100
var speed = 0
var facing := Vector2(1, 0)
var acceleration = 0.5
onready var state_label = $StateLabel
onready var rays = $Rays.get_children()

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

func _physics_process(delta: float) -> void:
	#if ray_right.is_colliding():
	#	print(ray_right.get_collider().name)
	pass

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)