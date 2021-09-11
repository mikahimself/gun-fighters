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

func _on_Bullet_body_entered(body) -> void:
	if body.is_in_group("Props"):
		print("Hit a prop")
		queue_free()
	if body.has_method("take_damage"):
		print("Hit a character")
		queue_free()

func is_outside_view_bounds() -> bool:
	return position.x > OS.get_screen_size().x or \
			position.x < 0.0 or \
			position.y > OS.get_screen_size().y or \
			position.y < 0.0
