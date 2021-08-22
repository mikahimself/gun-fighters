extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")

func _input(event):
	if event.is_action_pressed("shoot"):
		print("shooty shoot", owner.facing)
		fire(owner.facing)

func fire(direction):
	var new_bullet = bullet.instance()
	new_bullet.direction = direction
	new_bullet.rotation = direction.angle()
	new_bullet.position =  self.global_position + 10 * direction
	add_child(new_bullet)
