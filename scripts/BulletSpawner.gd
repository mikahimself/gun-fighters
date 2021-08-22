extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")

func _input(event):
	if event.is_action_pressed("shoot"):
		print("shooty shoot", owner.facing_direction)
		fire(owner.facing_direction)

func fire(direction):
	var new_bullet = bullet.instance()
	new_bullet.direction = direction
	new_bullet.position = 15 * direction
	add_child(new_bullet)
