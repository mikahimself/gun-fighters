extends Area2D

var direction = Vector2()
export var speed = 175

func _ready():
	pass

func _process(delta):
	if is_outside_view_bounds():
		queue_free()
	var motion = direction * speed * delta
	translate(motion)

func is_outside_view_bounds():
	return position.x > OS.get_screen_size().x or \
			position.x < 0.0 or \
			position.y > OS.get_screen_size().y or \
			position.y < 0.0
