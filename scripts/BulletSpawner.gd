extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")
onready var world = get_node("/root/World")

func _input(event):
	if event.is_action_pressed("shoot_%s" %owner.playerID):
		fire(owner.facing)

func fire(direction):
	if not $CooldownTimer.is_stopped():
		return
	$CooldownTimer.start()
	var bullet_offset = 10 if (direction.y == 1) else 10
	var new_bullet = bullet.instance()
	new_bullet.direction = direction
	new_bullet.add_to_group("bullets")
	new_bullet.rotation = direction.angle()
	new_bullet.position = self.global_position + bullet_offset * direction
	world.add_child(new_bullet)
	
