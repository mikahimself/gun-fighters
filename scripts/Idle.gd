extends "res://scripts/Motion.gd"

var slow_down_time = 0.25
var slow_down_elapsed = 0

func enter(_msg := {}) -> void:
	print("Player Idle")
	print(owner.facing)
	if (owner.facing.y == -1):
		owner.play_animation("Idle_Up")
	else:
		owner.play_animation("Idle_Down")

func process(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction:
		state_machine.transition_to("Move")
		return
	if owner.speed > 0.1:
		slow_down(delta)
	check_ledge()

func check_ledge() -> bool:
	var offset = 5
	var positions = [owner.position + Vector2(-offset,  6), 
										owner.position + Vector2(offset,  6),
										owner.position + Vector2(0, -offset + 6),
										owner.position + Vector2(0,  offset + 6)]
	var edges = []
	for x in positions.size():
		var map_pos = owner.tilemap.world_to_map(positions[x])
		if owner.tilemap.get_cell(map_pos.x, map_pos.y) == -1:
			edges.append(x)
	if (edges.size() > 0):
		state_machine.transition_to("OnLedge", { "edges": edges} )
		return true
	return false

func slow_down(delta) -> void:
	if slow_down_elapsed < slow_down_time:
		slow_down_elapsed += delta
		owner.speed = lerp(50, 0, slow_down_elapsed / slow_down_time * 2)
		var vel = owner.speed * delta * owner.facing.normalized()
		owner.move_and_collide(vel)
		owner.check_borders()
	if owner.speed <= 0.15:
		owner.speed = 0
		slow_down_elapsed = 0

func exit() -> void:
	pass
