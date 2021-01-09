extends KinematicBody2D

var myVelocity = Vector2.ZERO
var max_speed = 50
var speed = 0
var facing := Vector2(1, 0)
var acceleration = 0.75

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Velocity: ", myVelocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
