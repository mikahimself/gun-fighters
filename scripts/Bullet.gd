extends KinematicBody2D

var direction = Vector2()
export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)

func _process(delta):
	var motion = direction * speed * delta
	var collision_info = move_and_collide(motion)


func is_outside_view_bounds():
	pass
