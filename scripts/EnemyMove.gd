extends "res://scripts/EnemyMotion.gd"

func _ready():
	pass

func enter(_msg := {}) -> void:
	print("Movement")
	#print(_msg.from)
	#print("Path size: ", path.size())
	if _msg.from == "idle":
		update_path(true)
	elif path.size() == 0:
		update_path(false)
	owner.path_timer.start()

func process(delta: float) -> void:
	if path.size() > 0 and owner.position.distance_to(path[0]) < 10:
		path.remove(0)
		print("removed path item")
		if path.size() < 5:
			#update_path(true)
			#owner.path_timer.start()
			print("path too short, going idle")
			print("Path is now ", path)
			state_machine.transition_to("EnemyIdle")
			return
	owner.facing = get_direction()
	owner.myPath.points = path

	if owner.facing.length() == 0:
		print("facing length 0, going idle")
		state_machine.transition_to("EnemyIdle")
		return

	var vel = calculate_velocity()

	owner.move_and_slide(vel)
	set_animation(owner.facing)
	
	if (path.size() > 0):
		return

func get_direction() -> Vector2:
	if (path.size() < 1):
		return Vector2.ZERO
	var x = 0
	var y = 0
	if (path[0].x < owner.position.x and owner.position.x - path[0].x > 3):
		x = -1
	elif (path[0].x > owner.position.x and path[0].x - owner.position.x > 3):
		x = 1
	if (path[0].y < owner.position.y):
		y = -1
	elif (path[0].y > owner.position.y):
		y = 1
	return Vector2(x, y)
	

func calculate_velocity() -> Vector2:
	var dir = owner.facing.normalized()
	owner.speed = lerp(owner.speed, owner.max_speed, owner.acceleration)
	return owner.speed * dir

func set_animation(input_direction: Vector2):
	match input_direction:
		Vector2(0, 1):
			owner.play_animation("Walk_Down")
		Vector2(0, -1):
			owner.play_animation("Walk_Up")
		Vector2(1, 0):
			owner.play_animation("Walk_Right")
		Vector2(1, 1):
			owner.play_animation("Walk_Right")
		Vector2(1, -1):
			owner.play_animation("Walk_Right")
		Vector2(-1, 0):
			owner.play_animation("Walk_Left")
		Vector2(-1, 1):
			owner.play_animation("Walk_Left")
		Vector2(-1, -1):
			owner.play_animation("Walk_Left")

func exit() -> void:
	pass
	

