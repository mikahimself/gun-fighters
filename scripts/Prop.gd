extends StaticBody2D

func _ready():
	var frame_no = int(randi() % ($Sprite.hframes - 1))
	$Sprite.frame = frame_no

func _on_Area2D_area_entered(area):
	if area.is_in_group("bullets"):
		$Sprite.frame = 2
		$Shadow.frame = 1
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$RootCollider2D.set_deferred("disabled", true)
		area.queue_free()
