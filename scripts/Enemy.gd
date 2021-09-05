extends KinematicBody2D

var facing = Vector2(-1, 0)
var prev_facing = Vector2.ZERO
var map_size
var max_speed = 35
var dash_speed = 80
var speed = 0
var acceleration = 0.5
var canDash = true
var player
var ray_len = 50
var angle_cov = deg2rad(45)
var max_view_dist = 200
var angle_btwn_rays = deg2rad(5)
var rays = []
var ray_count

onready var line2d = $Line2D
onready var navigation = get_tree().get_root().get_node("World/Navigation2D")
onready var tilemap = get_tree().get_root().get_node("World/Navigation2D/TileMapSand")
onready var myPath = get_tree().get_root().get_node("World/Line2D")
onready var state_machine = get_node("StateMachine")
onready var path_timer = get_node("PathTimer")
onready var ray = get_node("RayCast2D")
var bullet = preload("res://scenes/Bullet.tscn")
onready var world = get_node("/root/World")

func _ready():
	generate_rays()
	pass

func _process(delta):
	if facing != prev_facing:
		prev_facing = facing
		ray.cast_to = Vector2(ray_len * facing.x, ray_len * facing.y)
	for index in rays.size():
		
		var angle = angle_btwn_rays * (index - ray_count / 2.0)
		rays[index].cast_to = facing.rotated(angle) * max_view_dist
	check_ray_collisions()


func check_ray_collisions():
	for ray in rays:
		if ray.is_colliding() and ray.get_collider().name == "Player":
			fire(facing)
			if position.distance_to(player.position) < 50 and state_machine.state.name != "EnemyChase":
				state_machine.transition_to("EnemyChase")

func _physics_process(delta: float) -> void:
	pass

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)

func generate_rays():
	ray_count = angle_cov / angle_btwn_rays

	for index in ray_count:
		var ray = RayCast2D.new()
		var angle = angle_btwn_rays * (index - ray_count / 2.0)
		ray.cast_to = Vector2.UP.rotated(angle) * max_view_dist
		add_child(ray)
		ray.add_to_group("rays")
		ray.enabled = true
		rays.append(ray)

func fire(direction):
	if not $CooldownTimer.is_stopped():
		return
	$CooldownTimer.start()
	var bullet_offset = 8 if (direction.y == 1) else 4
	var new_bullet = bullet.instance()
	new_bullet.direction = direction
	new_bullet.add_to_group("bullets")
	new_bullet.rotation = direction.angle()
	new_bullet.position = self.global_position + bullet_offset * direction
	world.add_child(new_bullet)
