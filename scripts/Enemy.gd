extends KinematicBody2D

var facing = Vector2(-1, 0)
var max_speed = 35
var dash_speed = 80
var speed = 0
var acceleration = 0.5
var canDash = true
var player

onready var line2d = $Line2D
onready var navigation = get_tree().get_root().get_node("World/Navigation2D")
onready var myPath = get_tree().get_root().get_node("World/Line2D")

func _ready():
	pass

func _physics_process(delta: float) -> void:
	pass

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)