extends KinematicBody2D

var direction = Vector2()
export var speed = 150

func _ready():
	# Untie from player movement
	self.set_as_toplevel(true)

func _process(delta):
	if is_outside_view_bounds():
		queue_free()

	var motion = direction * speed * delta
	var collision_info = move_and_collide(motion)
	if collision_info:
		queue_free()

func is_outside_view_bounds():
	return position.x > OS.get_screen_size().x or \
			position.x < 0.0 or \
			position.y > OS.get_screen_size().y or \
			position.y < 0.0
