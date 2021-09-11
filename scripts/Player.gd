extends KinematicBody2D

var myVelocity = Vector2.ZERO
var max_speed = 35
var dash_speed = 100
var speed = 0
var playerID = 0;
var facing := Vector2(1, 0)
var previous_direction: Vector2
var acceleration = 0.5
var canDash = true
var tilemap: TileMap
var initial_position
var offset_x = 32
var offset_y = 16
var tilepos

onready var state_label = $StateLabel
onready var rays = $Rays.get_children()
var facing_direction = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position
	$StateMachine.connect("transitioned", self, "on_state_transitioned")
	tilemap = get_tree().get_root().get_node("World/Navigation2D/TileMapSand")

func on_state_transitioned(state: String):
	state_label.set_text(state)

func check_borders() -> void:
	if position.x < 8 + offset_x:
		position.x = 8 + offset_x
	if position.x > 472 + offset_x:
		position.x = 472 + offset_x
	if position.y > 312 + offset_y:
		position.y = 312 + offset_y
	if position.y < 8 + offset_y:
		position.y = 8 + offset_y

func _physics_process(delta: float) -> void:
	tilepos = tilemap.world_to_map(position)

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)

func get_map_position() -> int:
	var pos = tilemap.world_to_map(position + Vector2(0, 6))
	return tilemap.get_cell(pos.x, pos.y)

func take_damage() -> void:
	pass