extends StaticBody2D

func _ready():
	var frame_no = int(randi() % $Sprite.hframes)
	$Sprite.frame = frame_no
